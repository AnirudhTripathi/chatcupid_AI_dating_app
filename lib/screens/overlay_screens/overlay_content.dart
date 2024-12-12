import 'dart:async';
import 'dart:ui';

import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/controllers/overlay_controllers.dart';
import 'package:chatcupid/screens/overlay_screens/sliding_segment_overlay.dart';
import 'package:chatcupid/screens/purchase_screens/bottom_sheet_payment.dart';
import 'package:chatcupid/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverlayContent extends StatefulWidget {
  const OverlayContent({Key? key}) : super(key: key);

  @override
  _OverlayContentState createState() => _OverlayContentState();
}

class _OverlayContentState extends State<OverlayContent> {
  final OverlayControllers controllers = Get.find<OverlayControllers>();
  bool isSwitched = true;
  int apiCallCount = 0;
  String? selectedEmoji;
  final TextEditingController contextTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadApiCallCount(); // Load count on initialization
    _startResetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: Container(
          height: Get.height / 2.2,
          width: 300.w,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 1,
              color: Colors.white,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10.h,
                  left: 10.w,
                  right: 10.w,
                ),
                child: Obx(
                  () => SlidingSegmentOverlay(
                    selectedIndex: controllers.selectedIndex.value,
                    onSegmentChanged: (index) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => (apiCallCount > 3)
                      ? _buildOutOfCreditScreen()
                      : (controllers.selectedIndex.value == 1
                          ? _buildSetContextScreen()
                          : _buildGetRizzScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetContextScreen() {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'mood',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmojiButton('🙂'),
              SizedBox(width: 10.w),
              _buildEmojiButton('🥰'),
              SizedBox(width: 10.w),
              _buildEmojiButton('🥺'),
              SizedBox(width: 10.w),
              _buildEmojiButton('😈'),
            ],
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: TextField(
              controller: contextTextEditingController,
              decoration: InputDecoration(
                hintText: 'type your context here...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              maxLines: null,
              expands: true,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'auto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: () {
                  if (apiCallCount <= 3) {
                    controllers.sendChatData(
                        selectedEmoji, contextTextEditingController.text);
                    apiCallCount++;
                    setState(() {});
                  }
                },
                icon: SvgPicture.asset(
                  CustomIcons.aiLogo,
                ),
                label: Text(
                  "Run",
                  style: TextStyle(color: Colors.black, fontSize: 15.sp),
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutOfCreditScreen() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          // Blurred text
          Text(
            "vknewrlofvnawee erg erber bber b er er b\n"
            "vknewrlofvnawee erg erber bber b er er b\n"
            "vknewrlofvnawee erg erber bber b er er b\n"
            "vknewrlofvnawee erg erber bber b er er b\n",
            style:
                TextStyle(fontSize: 15.sp, color: Colors.white.withOpacity(.2)),
          ),
          // Blur effect
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // Content on top of the blur
          Center(
            child: ClipRRect(
              child: Container(
                height: 300.h,
                width: 250.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Icon(Icons.lock_open_outlined,
                        color: Colors.white, size: 30),
                    SizedBox(height: 10),
                    Text(
                      "Out of credits",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    FilledButton(
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
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
                      child: Text(
                        "Buy Chatcupid Premium",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "or",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    GradientText(
                      gradientText: 'Refer And Earn',
                      size: 10.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetRizzScreen() {
    if (apiCallCount <= 3) {
      controllers.sendChatData(
          selectedEmoji, contextTextEditingController.text);
      apiCallCount++;
    }
    // setState(() {});
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controllers.isLoading.value)
              Center(
                child: Lottie.asset('assets/animations/heart_emoji.json',
                    width: 100.w),
              )
            else if (controllers.replyData.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'Press "Run" to generate replies',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          await Clipboard.setData(ClipboardData(
                              text: controllers.replyData['reply']['reply1'] ??
                                  ''));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Copied to clipboard: Reply 1')),
                          );
                        } catch (e) {
                          print("Error: $e");
                        }
                      },
                      child: Text(
                        controllers.replyData['reply']['reply1'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(
                            text: controllers.replyData['reply']['reply2'] ??
                                ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Copied to clipboard: Reply 2')),
                        );
                      },
                      child: Text(
                        controllers.replyData['reply']['reply2'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(
                            text: controllers.replyData['reply']
                                    ['decode_convo'] ??
                                ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Copied to clipboard: Decoded Conversation')),
                        );
                      },
                      child: Text(
                        controllers.replyData['reply']['decode_convo'] ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'tap to copy',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji = emoji;
        });
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: selectedEmoji == emoji ? Colors.pink : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(80),
        ),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Future<void> _loadApiCallCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      apiCallCount = prefs.getInt('apiCallCount') ?? 0;
    });
  }

  Future<void> _saveApiCallCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('apiCallCount', apiCallCount);
  }

  void _startResetTimer() {
    // Calculate time remaining until midnight
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = midnight.difference(now);

    Timer(timeUntilMidnight, () {
      setState(() {
        apiCallCount = 0; // Reset API call count
        _saveApiCallCount(); // Save the reset count
      });
    });
  }
}
