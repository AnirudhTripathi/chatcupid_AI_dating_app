import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/services/auth_status_service.dart';
import 'package:chatcupid/services/firebase_service.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential =
          await FirebaseService.firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await Get.find<AuthStatusService>().setLoginStatus(true);

        final userName = userCredential.user!.displayName ?? 'User';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', userName);

        bool isRegistered =
            await _checkIfUserRegistered(userCredential.user!.email!);
        if (isRegistered) {
          Get.offNamed(RoutesHelper.bottomNavbar);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Welcome back! Good to see you again.")));
        } else {
        await _saveUserDetailsToFirestore(userCredential.user);
        await Get.find<OnboardingController>().fetchUserName();
          Get.offNamed(RoutesHelper.firstOnboardingScreen);
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error signing in: $e")));
    }
  }

  Future<bool> _checkIfUserRegistered(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        print("User data found: $userData");

        // Check if onboarding is completed
        return true;
      } else {
        print("No user found with email: $email");
        return false;
      }
    } catch (e) {
      print("Error checking if user is registered: $e");
      return false;
    }
  }

   Future<void> _saveUserDetailsToFirestore(User? user) async {
    if (user != null) {
      final userCollection = FirebaseFirestore.instance.collection('users');

      try {
        // Use doc(user.uid) to create or update the document with the user's UID
        await userCollection.doc(user.uid).set({ 
          'name': user.displayName,
          'profilePicture': user.photoURL,
          'email': user.email,
        });

        print("User details saved/updated in Firestore with UID: ${user.uid}");
      } catch (e) {
        print("Error saving user details to Firestore: $e");
      }
    }
  }

  static Future<String?> getIdToken() async {
    try {
      User? user = FirebaseService.firebaseAuth.currentUser;

      if (user != null) {
        String? idToken = await user.getIdToken();
        print("ID Token: $idToken");
        return idToken;
      }
    } catch (e) {
      print("Error getting ID token: $e");
    }

    return null;
  }
}
