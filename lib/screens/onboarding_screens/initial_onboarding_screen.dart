import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/screens/auth_screens/login_screen.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/screens/onboarding_screens/widgets/intro_icon_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InitialOnboardingScreen extends StatelessWidget {
  const InitialOnboardingScreen({super.key});

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
                  height: 130.h,
                ),
                Text(
                  "Get the rizz you deserve!",
                  style: TextStyle(
                      fontSize: 14.sp, color: AppPallete.lightGreyFontColor),
                ),
                SvgPicture.asset(
                  CustomIcons.chatcupidIcon,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "A perfect wingman to help you express your \n deepest romantic desire creatively!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppPallete.lightGreyFontColor,
                  ),
                ),
                SizedBox(
                  height: 55.h,
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: ActionSlider.standard(
                      toggleColor: AppPallete.primaryColor,
                      backgroundColor:
                          AppPallete.secondaryColor.withOpacity(.48),
                      icon: const Icon(
                        Icons.favorite,
                        color: AppPallete.whiteColor,
                      ),
                      height: 55.h,
                      width: 339.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppPallete.whiteColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 72.w,
                          ),
                          SvgPicture.asset(
                            "assets/svgs/continue_slider_icon.svg",
                          ),
                        ],
                      ),
                      action: (controller) async {
                        controller.loading();
                        await Future.delayed(const Duration(seconds: 1));
                        controller.success();
                        await Future.delayed(const Duration(seconds: 1));
                        Get.toNamed(RoutesHelper.loginScreen);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
