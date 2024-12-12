import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferButton extends StatelessWidget {
   ReferButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          elevation: 0,
          context: context,
          builder: (BuildContext context) {
            return BottomSheetReferContent();
          },
        );
      },
      child: Container(
        width: Get.width - 40.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: const GradientBorder(
            borderGradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFF00E0FF),
                Color(0xFFFF8FF4),
              ],
              tileMode: TileMode.repeated,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(0.0),
            ),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              CustomIcons.totalEarned,
              width: 30.w,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
             
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            // SizedBox(width: 8.w),
            Spacer(),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetReferContent extends StatelessWidget {
  const BottomSheetReferContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 350.h,
          width: Get.width,
          padding: EdgeInsets.all(16.0.w),
          decoration: BoxDecoration(
            color: AppPallete.whiteColor.withOpacity(.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Text(
                'Refer and earn',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                '1 Day premium',
                style: TextStyle(fontSize: 26.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'for every signup',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 8.h),
              Image.asset("assets/images/cash_text.png"),
              SizedBox(height: 8.h),
              Text(
                'when your friend buys a subscription',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(255, 255, 255, 255)),
              ),
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140.w, 45.h),
                  backgroundColor: AppPallete.whiteColor,
                  foregroundColor: AppPallete.blackColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                onPressed: () async {
                  String referralLink = await generateReferralLink();
                  await shareReferralLink(referralLink);
                },
                icon: Icon(Icons.share),
                label: const Text(
                  "Share link",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> generateReferralLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    if (userId.isEmpty) {
      // Generate a unique user ID if not already set
      userId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('user_id', userId);
    }

    // Construct the referral link with the user ID
    String baseUrl =
        "https://play.google.com/store/apps/details?id=com.app.chatcupid";
    String referralLink = "$baseUrl&referrer=user_id%3D$userId";

    return referralLink;
  }

  Future<void> shareReferralLink(String referralLink) async {
    await Share.share(
      'Check out this awesome app! Use my referral link to sign up: $referralLink',
      subject: 'Join me on ChatCupid!',
    );
  }
}
