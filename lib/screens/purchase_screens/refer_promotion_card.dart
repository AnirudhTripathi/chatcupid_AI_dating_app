import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferPromotionCard extends StatelessWidget {
  const ReferPromotionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: Get.width,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppPallete.purchaseBackgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Text(
            "Earn 50 cupid coins",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "for every signup",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Plus ₹100 cash",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "when your friend buys a subscription",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.whiteColor,
              foregroundColor: AppPallete.blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: (){},
            // onPressed: () async {
            //   String referralLink = await generateReferralLink();
            //   await shareReferralLink(referralLink);
            // },
            icon: Icon(Icons.share),
            label: Text(
              "Share link",
            ),
          ),
        ],
      ),
    );
  }
}