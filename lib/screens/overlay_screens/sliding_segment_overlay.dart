import 'package:chatcupid/controllers/overlay_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidingSegmentOverlay extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onSegmentChanged;

  const SlidingSegmentOverlay({
    Key? key,
    required this.selectedIndex,
    this.onSegmentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OverlayControllers controllers = Get.find<OverlayControllers>();
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              controllers.updateSelectedIndex(1);
              if (onSegmentChanged != null) {
                onSegmentChanged!(1);
              }
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: controllers.selectedIndex.value == 1
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "set context",
                  style: TextStyle(
                    color: controllers.selectedIndex.value == 1
                        ? Colors.black
                        : Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              controllers.updateSelectedIndex(0);
              if (onSegmentChanged != null) {
                onSegmentChanged!(0);
              }
            },
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: controllers.selectedIndex.value == 0
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "get rizz",
                  style: TextStyle(
                    color: controllers.selectedIndex.value == 0
                        ? Colors.black
                        : Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
