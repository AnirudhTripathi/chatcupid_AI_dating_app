import 'package:chatcupid/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxString userName = ''.obs; // Variable to store the user's name
  RxString userProfilePic = ''.obs; // Variable to store the user's name

  RxString relationshipStatus = ''.obs; // Store relationship status

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Load data from SharedPreferences on init
  }

  Future<void> fetchUserName() async {
    final user = FirebaseService.firebaseAuth.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          userName.value = userDoc.get('name') ?? '';
          userProfilePic.value = userDoc.get('profilePicture') ?? '';

          _saveUserData();
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    }
  }
  

  Future<void> saveRelationshipStatus(String status) async {
    final user = FirebaseService.firebaseAuth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          // Use update() to add a new field
          'relationshipStatus': status,
        });
        relationshipStatus.value = status; // Update the local state
      } catch (e) {
        print('Error saving relationship status: $e');
      }
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName.value);
    await prefs.setString('userProfilePic', userProfilePic.value);
    await prefs.setString('relationshipStatus', relationshipStatus.value);
  }


  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('userName') ?? '';
    userProfilePic.value = prefs.getString('userProfilePic') ?? '';
    relationshipStatus.value = prefs.getString('relationshipStatus') ?? '';
  }

  Future<void> saveUserDetails({
    required String age,
    required String? gender,
    required String country,
  }) async {
    final user = FirebaseService.firebaseAuth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'age': age,
          'gender': gender,
          'country': country,
        });
      } catch (e) {
        print('Error saving user details: $e');
      }
    }
  }
}