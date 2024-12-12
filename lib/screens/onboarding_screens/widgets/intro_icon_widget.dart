import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroIconWidget extends StatelessWidget {
  const IntroIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "assets/images/intro_icon.png",
        width: 350.w,
        height: 350.w,
      ),
    );
  }
}
