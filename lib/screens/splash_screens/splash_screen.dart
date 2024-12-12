import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/services/auth_status_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  // final bool isLoggedIn =
  //   await Get.find<AuthStatusService>().checkLoginStatus();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (await Get.find<AuthStatusService>().checkLoginStatus()) {
        Get.offAllNamed(RoutesHelper.bottomNavbar);
      } else {
        Get.offAllNamed(RoutesHelper.initialOnboardingScreen);
      }
    });
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(
        color: AppPallete.blackColor,
      ),
      child: Center(
        child: SvgPicture.asset(
          CustomIcons.chatcupidIcon,
          // width: 100.w,
        ),
      ),
    );
  }
}
