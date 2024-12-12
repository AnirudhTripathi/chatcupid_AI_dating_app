import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StreakAssetWidget extends StatelessWidget {
  const StreakAssetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFFB8DF1).withOpacity(0.3),
          spreadRadius: .8,
          blurRadius: 25,
          offset: Offset(8, 8),
        ),
      ]),
      child: SvgPicture.asset(
        CustomIcons.streakIcon,
        width: 50.w,
        height: 50.w,
      ),
    );
  }
}
