import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/services/auth_services.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:chatcupid/screens/onboarding_screens/widgets/intro_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:toastification/toastification.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 0,
            top: 80.h,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const IntroIconWidget(),
                SizedBox(
                  height: 160.h,
                ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 138.h,
                      width: 359.w,
                      decoration: BoxDecoration(
                        color: AppPallete.secondaryColor.withOpacity(0.48),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            child: AuthButton(
                              buttonText: "Login with Google",
                              onPressed: () async {
                                try {
                                  await AuthService().signInWithGoogle(context);
                                } catch (e) {
                                  print("Error signing in with Google: $e");
                                }
                              },
                              icon: Image.asset(
                                CustomIcons.googleIcon,
                                width: 24.w,
                                height: 24.w,
                              ),
                              backgroundColor:
                                  AppPallete.blackColor.withOpacity(.35),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AuthButton(
                              buttonText: "Login with Apple",
                              onPressed: () {
                                // Get.toNamed(RoutesHelper.firstOnboardingScreen);
                              },
                              icon: SvgPicture.asset(
                                CustomIcons.appleIcon,
                                width: 24.w,
                                height: 24.w,
                              ),
                              backgroundColor:
                                  AppPallete.blackColor.withOpacity(.35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By registering and login you agree with our \n',
                    style: const TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
