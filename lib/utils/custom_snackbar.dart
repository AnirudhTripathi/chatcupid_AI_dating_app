import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
      colorText: Colors.pinkAccent,
      snackPosition: SnackPosition.TOP,
    );
  }
}