import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/screens/onboarding_screens/widgets/indicator_container.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SecondOnboardingScreem extends StatefulWidget {
  const SecondOnboardingScreem({Key? key}) : super(key: key);

  @override
  State<SecondOnboardingScreem> createState() => _SecondOnboardingScreemState();
}

class _SecondOnboardingScreemState extends State<SecondOnboardingScreem> {
  List<String> status = [
    'Single 🙂',
    'In a relationship 💏',
    'Crushing 🥰',
    'Married 💑',
    'It’s complicated',
    'Broken hearted 💔',
  ];
  int? _selectedIndex;
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/second_onboarding_screen.png",
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
                    "Are you single, taken, or it's complicated? Let us know where you're at! 💞",
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: status.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: AuthButton(
                        mainAxisAlignment: MainAxisAlignment.start,
                        buttonText: status[index],
                        buttonTextColor: (_selectedIndex == index)
                            ? AppPallete.blackColor
                            : AppPallete.whiteColor,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
                            onboardingController
                                .saveRelationshipStatus(status[index]);
                          });
                        },
                        backgroundColor: (_selectedIndex == index)
                            ? AppPallete.whiteColor
                            : AppPallete.onboardingButtonColor
                                .withOpacity(0.21),
                      ),
                    );
                  },
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
                    if (_selectedIndex != null) {
                      // Check if an option is selected
                      if (onboardingController.selectedIndex.value < 2) {
                        onboardingController.selectedIndex.value++;
                        Get.offNamed(RoutesHelper.thirdOnboardingScreen);
                      } else {
                        // Navigate to the main app after the last screen
                      }
                    } else {
                      // Show an error message using the Scaffold's SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select a relationship status"),
                        ),
                      );
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
