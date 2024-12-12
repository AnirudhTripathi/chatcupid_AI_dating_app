import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SlidingSegment extends StatefulWidget {
  int selectedIndex;

  SlidingSegment({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<SlidingSegment> createState() => _SlidingSegmentState();
}

class _SlidingSegmentState extends State<SlidingSegment> {
  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> myTabs = <int, Widget>{
      0: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  CustomIcons.chatSlidingIcon,
                  width: 20.w,
                  height: 20.w,
                  // ignore: deprecated_member_use
                  color:
                      widget.selectedIndex == 0 ? Colors.black : Colors.white,
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    "Chat",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: widget.selectedIndex == 0
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      1: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  CustomIcons.settingsIcon,
                  width: 20.w,
                  height: 20.w,
                  // ignore: deprecated_member_use
                  color:
                      widget.selectedIndex == 1 ? Colors.black : Colors.white,
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: widget.selectedIndex == 1
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    };

    return CustomSlidingSegmentedControl<int>(
      fromMax: true,
      height: 50.h,
      padding: 5.w,
      decoration: BoxDecoration(
        color: AppPallete.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      thumbDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      children: myTabs,
      initialValue: widget.selectedIndex,
      onValueChanged: (i) {
        setState(() {
          Get.find<ChatControllers>().selectedIndex.value = i;
          widget.selectedIndex = i;
        });
      },
    );
  }
}
