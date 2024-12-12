import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/screens/home_screens/home_screen.dart';
import 'package:chatcupid/screens/like_screens/like_screen.dart';
import 'package:chatcupid/screens/purchase_screens/purchase_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../controllers/like_screen_controller.dart';

class CustomFloatingNavbar extends StatefulWidget {
  const CustomFloatingNavbar({Key? key}) : super(key: key);

  @override
  _CustomFloatingNavbarState createState() => _CustomFloatingNavbarState();
}

final LikeController likeScreenController = Get.put(LikeController());

class _CustomFloatingNavbarState extends State<CustomFloatingNavbar> {
  int selectedItem = 1;

  final List<Widget> _screens = [

    ShowCaseWidget(
      onStart: (index, key) {
        print('Showcase started at index: $index');
      },
      onComplete: (index, key) {
        print('Showcase completed at index: $index');
        if (index == likeScreenController.showcaseKeys.length - 1) {
          likeScreenController.setShowcaseStatus(false);
        }
      },
      builder: (context) => LikeScreen(),
    ),
    
    ShowCaseWidget(
      builder: (context) => HomeScreen(),
    ),

    ShowCaseWidget(
      onStart: (index, key) {
        print('Showcase started at index: $index');
      },
      onComplete: (index, key) {
        print('Showcase completed at index: $index');
        if (index == likeScreenController.showcaseKeys.length - 1) {
          likeScreenController.setShowcaseStatus(false);
        }
      },
      builder: (context) => PurchaseScreen(),
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _screens[selectedItem],
        Positioned(
          bottom: 35.h,
          left: 90.w,
          right: 90.w,
          height: 60.h,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(100),
              color: AppPallete.backgroundColor.withOpacity(.50),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ClipPath(
                // clipper: MyCustomClipper(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 8, sigmaX: 8),
                  child: Container(),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 35.h,
            left: 90.w,
            right: 90.w,
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildBNBItem(CustomIcons.likeIcon, 0),
                _buildBNBItem(CustomIcons.chatIcon, 1),
                _buildBNBItem(CustomIcons.purchaseIcon, 2),
              ],
            ))
      ],
    );
  }

  Widget _buildBNBItem(String icon, index) {
    return ZoomTapAnimation(
      onTap: () {
        setState(() {
          selectedItem = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: selectedItem == index
                ? Colors.white
                : AppPallete.backgroundColor.withOpacity(.50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              icon,

              // ignore: deprecated_member_use
              color: selectedItem == index ? Colors.black : Colors.white,
              width: 5.w,
              height: 5.w,
            ),
          ),
        ),
      ),
    );
  }
}
