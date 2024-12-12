import 'package:chatcupid/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxMap userData = {}.obs;
  RxBool isLoading = false.obs;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    isLoading.value = true; // Start loading
    final user = FirebaseService.firebaseAuth.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          userData.value = userDoc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    isLoading.value = false; // End loading
  }

  // Update user data in Firestore
  Future<void> updateUserData(String fieldName, String newValue) async {
    final user = FirebaseService.firebaseAuth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({fieldName: newValue});


        userData.value = {...userData.value, fieldName: newValue};

        print(
            "User data updated successfully!"); // Optional success message in console
      } catch (e) {
        print('Error updating user data: $e');

        Get.snackbar(
          'Error',
          'Failed to update profile.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
