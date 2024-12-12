import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/screens/onboarding_screens/widgets/indicator_container.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FirstOnboardingScreen extends StatelessWidget {
  FirstOnboardingScreen({Key? key}) : super(key: key);

  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/first_onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 65.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IndicatorContainer(index: 0),
                  SizedBox(width: 10.w),
                  IndicatorContainer(index: 1),
                  SizedBox(width: 10.w),
                  IndicatorContainer(index: 2),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 80.h,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Hey there! 👋 What's the name we'll be calling you by? ",
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Obx(
                  () => AuthButton(
                    buttonText: onboardingController.userName.value.isNotEmpty
                        ? onboardingController
                            .userName.value // Display user name if available
                        : "SuperCupid         ",
                    onPressed: () {},
                    mainAxisAlignment: MainAxisAlignment.start,
                    backgroundColor:
                        AppPallete.onboardingButtonColor.withOpacity(.21),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 26.h,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthButton(
                  buttonText: "Next",
                  onPressed: () {
                    if (onboardingController.selectedIndex.value < 2) {
                      onboardingController.selectedIndex.value++;
                      Get.offNamed(RoutesHelper
                          .secondOnboardingScreen); // Update route as needed
                    } else {
                      // Navigate to the main app after the last screen
                      // Example: Get.offNamed(RoutesHelper.mainScreen);
                    }
                  },
                  buttonTextColor: AppPallete.blackColor,
                  backgroundColor: AppPallete.whiteColor,
                  googleIcon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
