// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:chatcupid/controllers/onboarding_controllers.dart';

class IndicatorContainer extends StatelessWidget {
  int index;
  IndicatorContainer({
    super.key,
    required this.index,
  });

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 5.h,
        width: 110.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: (onboardingController.selectedIndex.value == index)
              ? const LinearGradient(
                  colors: [Colors.white, Color(0xFF00E0FF), Color(0xFFFF8FF4)])
              : LinearGradient(colors: [
                  AppPallete.onboardingButtonColor.withOpacity(.20),
                  AppPallete.onboardingButtonColor.withOpacity(.20),
                ]),
        ),
      ),
    );
  }
}
