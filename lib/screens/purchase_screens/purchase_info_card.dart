// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PurchaseInfoCard extends StatelessWidget {
  String iconPath;
  String value;
  String description;
  PurchaseInfoCard({
    super.key,
    required this.iconPath,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 165.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppPallete.purchaseBackgroundColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(height: 10.h),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
