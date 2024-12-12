import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/screens/chat_screens/chat_setting.dart';
import 'package:chatcupid/screens/chat_screens/texting_screen.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:chatcupid/screens/chat_screens/widgets/sliding_segment_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.name}) : super(key: key);
  String name;
  // final ChatControllers controllers = Get.find<ChatControllers>();
  final newChatId = FirebaseFirestore.instance.collection('chats').doc().id;

  @override
  Widget build(BuildContext context) {
    final ChatControllers controllers = Get.find<ChatControllers>(tag: name);
    return Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        text: name,
        textSize: 25.sp,
        // mainAxisAlignment: MainAxisAlignment.end,
        profileIcon:
            "https://pics.craiyon.com/2023-10-28/5ad22761b9cf4196abba9a20dcc50c61.webp",
        onPressed: () {
          // Get.toNamed(RoutesHelper.chatScreenSetting);
        },
        backButton: true,
        appbarIcon: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SizedBox(height: 50,)
          Image.asset(
            "assets/images/third_onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 180.h,
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                  color: AppPallete.homeScreenBackgroundColor.withOpacity(.50),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
            ),
          ),

          GetBuilder<ChatControllers>(
            init: ChatControllers(personaName: name),
            builder: (controllers) => Column(
              children: [
                SizedBox(height: 80.h),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    left: 10.h,
                    right: 10.h,
                  ),
                  child: Obx(
                    () => SlidingSegment(
                      selectedIndex: controllers.selectedIndex.value,
                    ),
                  ),
                ),
                SizedBox(height: 45.h),
                Expanded(
                  child: Obx(
                    () => controllers.selectedIndex.value == 0
                        ?   ShowCaseWidget(
      builder: (context) =>TextingScreen(controllers: controllers),)
                        : ChatSettingsScreen(
                            chatId: newChatId,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
