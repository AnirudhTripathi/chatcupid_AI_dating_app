import 'dart:async';
import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/screens/purchase_screens/bottom_sheet_payment.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:chatcupid/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BuyButton extends StatefulWidget {
  const BuyButton({Key? key}) : super(key: key);

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
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
            return const BottomSheetContent();
          },
        );
      },
      child: Container(
          height: 50.h,
          width: Get.width - 40.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: GradientBorder(
              borderGradient: LinearGradient(
                colors: [
                  const Color(0xFFFFFFFF),
                  const Color(0xFF00E0FF).withOpacity(.5),
                  const Color(0xFFFF8FF4),
                ],
                tileMode: TileMode.repeated,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: const GradientRotation(0.0),
              ),
              width: 3,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                CustomIcons.heartIcon,
                width: 30.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              const Text(
                "Buy Chatcupid Premium",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          )),
    );
  }
}
