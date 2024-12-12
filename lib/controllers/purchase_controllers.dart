import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseControllers extends GetxController {
  final List<GlobalKey> showcaseKeys = [GlobalKey()];
  RxBool purchaseShowShowcase = true.obs;

  @override
  void onInit() {
    super.onInit();

    _loadShowcaseStatus();
  }

  void setShowcaseStatus(bool value) async {
    purchaseShowShowcase.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showPurchaseScreenShowcase', value);
  }

  Future<void> _loadShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    purchaseShowShowcase.value =
        prefs.getBool('showPurchaseScreenShowcase') ?? true;
  }
}
