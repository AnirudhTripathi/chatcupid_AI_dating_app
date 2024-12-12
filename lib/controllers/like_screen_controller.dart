import 'package:chatcupid/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeController extends GetxController {
  RxBool isLiked = false.obs;
  final String? postId; // Add postId

  LikeController({this.postId}); // Initialize with postId

  RxList<QueryDocumentSnapshot> filteredPosts = <QueryDocumentSnapshot>[].obs;
  RxBool isLoading = true.obs;

  final Set<String> _likedPostIds = {};

  final Set<String> _unlikedPostIds = {};

  RxBool shouldShowShowcase = true.obs;

  final List<GlobalKey> showcaseKeys = [GlobalKey()];



  @override
  void onInit() {
    super.onInit();
    _loadShowcaseStatus();
    

    _loadLikedAndUnlikedPosts();
    fetchAndFilterPosts();

     
  }



void setShowcaseStatus(bool value) async {
  shouldShowShowcase.value = value;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showLikeScreenShowcase', value);
}

  
Future<void> _loadShowcaseStatus() async {
  final prefs = await SharedPreferences.getInstance();
  shouldShowShowcase.value = prefs.getBool('showLikeScreenShowcase') ?? true;
}


  Future<void> fetchAndFilterPosts() async {
    isLoading.value = true;

    try {
      final user = FirebaseService.firebaseAuth.currentUser;
      if (user != null) {
        // Fetch user's relationship status
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userRelationshipStatus = userDoc.get('relationshipStatus');

        // Fetch and filter posts
        final postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('relationshipStatus',
                arrayContainsAny: [userRelationshipStatus]).get();

        filteredPosts.assignAll(postsSnapshot.docs);
      }
    } catch (e) {
      print('Error fetching and filtering posts: $e');
    } finally {
      isLoading.value = false;
    }
  }



  void toggleLike() async {
    isLiked.value = !isLiked.value;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userEmail = user.email ?? '';

        final postRef =
            FirebaseFirestore.instance.collection('posts').doc(postId);

        if (isLiked.value) {
          _likedPostIds.add(postId!);
          _unlikedPostIds.remove(postId!);

          await postRef.update({
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([userEmail]),
          });
        } else {
          _unlikedPostIds.add(postId!);
          _likedPostIds.remove(postId!);

          await postRef.update({
            'likes': FieldValue.increment(-1),
            'likedBy': FieldValue.arrayRemove([userEmail]),
          });
        }
        _saveLikedAndUnlikedPosts();
      }
    } catch (e) {
      print('Error updating likes: $e');

      isLiked.value = !isLiked.value;
    }
  }

  Future<void> _saveLikedAndUnlikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedPosts', _likedPostIds.toList());
    await prefs.setStringList('unlikedPosts', _unlikedPostIds.toList());
  }

  Future<void> _loadLikedAndUnlikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('likedPosts') ?? [];
    final unlikedPosts = prefs.getStringList('unlikedPosts') ?? [];

    _likedPostIds.addAll(likedPosts);
    _unlikedPostIds.addAll(unlikedPosts);
  }
}
