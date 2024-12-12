import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color backgroundColor;
  final IconData? googleIcon;
  final MainAxisAlignment mainAxisAlignment;
  final Color buttonTextColor;

  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    required this.backgroundColor,
    this.googleIcon,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.buttonTextColor = AppPallete.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: backgroundColor,
          ),
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              fixedSize: Size(343.w, 56.h),
              backgroundColor: AppPallete.transparentColor,
              shadowColor: AppPallete.transparentColor,
            ),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: 8.w),
                ],
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: buttonTextColor,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Icon(
                  googleIcon,
                  color: AppPallete.blackColor,
                  size: 18.sp, // Adjust icon size as needed
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


