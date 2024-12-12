import 'dart:math';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/screens/chat_screens/widgets/chat_bubble.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MeSectionTextingScreen extends StatefulWidget {
  MeSectionTextingScreen({Key? key, this.controllers}) : super(key: key);
  final ChatControllers? controllers;

  @override
  State<MeSectionTextingScreen> createState() => _MeSectionTextingScreenState();
}

class _MeSectionTextingScreenState extends State<MeSectionTextingScreen> {
  // Remove: final ChatControllers controllers = Get.find<ChatControllers>();
  // final ChatControllers controllers =
  //     Get.find<ChatControllers>(tag: 'Me Section');
  late ChatControllers _meSectionController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // final GlobalKey<ListViewBuilderState> _listViewKey =
  //     GlobalKey<ListViewBuilderState>();

  @override
  void initState() {
    super.initState();
    _meSectionController = Get.arguments['controllers'];
    _meSectionController
        .fetchMeSectionMessages(); // Fetch "me_section" messages
    _meSectionController.messages
        .listen((_) => _scrollToBottom()); // Scroll to bottom on new message
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to the bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppPallete.homeScreenBackgroundColor.withOpacity(.50),
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        text: "Me Section",
        textSize: 25.sp,
        // mainAxisAlignment: MainAxisAlignment.end,
        profileIcon:
            "https://firebasestorage.googleapis.com/v0/b/chatcupid-87b76.appspot.com/o/users%2Fme%20section.png?alt=media&token=0435fbd1-f18c-4684-bd2f-4205f742e0c8",
        onPressed: () {
          // Get.toNamed(RoutesHelper.chatScreenSetting);
        },
        backButton: true,
        appbarIcon: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/third_onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shrinkWrap: true,
                      itemCount: _meSectionController.messages.length,
                      itemBuilder: (context, index) {
                        final message = _meSectionController.messages[index];
                        return ChatBubble(
                          text: message.text,
                          isSender: message.isSender,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    right: 10,
                    left: 10,
                  ),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 320.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black26,
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            fillColor:
                                AppPallete.backgroundColor.withOpacity(.5),
                            contentPadding: const EdgeInsets.all(15),
                            hintText: "Type your message here",
                            hintStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              // Change to IconButton
                              icon: const Icon(Icons.send_rounded),
                              onPressed: () {
                                if (_messageController.text.isNotEmpty) {
                                  _meSectionController.sendMessage(
                                      _messageController.text,
                                      isMeSection:
                                          true); // Specify it's for "me_section"
                                  _messageController
                                      .clear(); // Clear the text field
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
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
