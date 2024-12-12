// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:chatcupid/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';

class PurchaseCard extends StatelessWidget {
  String offer;
  String buttonText;
  PurchaseCard({
    super.key,
    required this.offer,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        border: GradientBorder(
          borderGradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFF56A5),
              Color(0xFF2ED2FD),
            ],
            tileMode: TileMode.repeated,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // stops: [0.0, 1.0],
            transform: GradientRotation(0.0),
          ),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                CustomIcons.cupidCoins,
                width: 30.w,
                // theme: SvgTheme(),
                height: 30.w,
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset(
                CustomIcons.exchnageIcon,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset(
                CustomIcons.totalEarned,
                width: 30.w,
                height: 30.w,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            offer,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppPallete.blackColor,
              backgroundColor: AppPallete.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
