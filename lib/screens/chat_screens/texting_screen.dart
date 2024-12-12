import 'dart:io';
import 'dart:math';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/screens/chat_screens/widgets/chat_bubble.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class TextingScreen extends StatefulWidget {
  TextingScreen({Key? key, required this.controllers}) : super(key: key);
  final ChatControllers controllers;

  @override
  State<TextingScreen> createState() => _TextingScreenState();
}

class _TextingScreenState extends State<TextingScreen> {
  // Remove: final ChatControllers controllers = Get.find<ChatControllers>();

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  bool _isLoading = false;
  final GlobalKey _attachFiles = GlobalKey();
  final GlobalKey _addEmoji = GlobalKey();
  final GlobalKey _send = GlobalKey();
  bool _hasShowcaseBeenShown = false;

  // final GlobalKey<ListViewBuilderState> _listViewKey =
  //     GlobalKey<ListViewBuilderState>();

  @override
  void initState() {
    super.initState();

    _checkAndShowShowcase();

    // Scroll to bottom whenever new messages are received
    widget.controllers.messages.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });

    // Scroll to bottom after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkAndShowShowcase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showcaseShown = prefs.getBool('textingShowcase') ?? false;

    if (!showcaseShown) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        ShowCaseWidget.of(context)
            .startShowCase([_attachFiles, _addEmoji, _send]);
      });
      await _saveShowcaseStatus();
    }

    setState(() {
      _hasShowcaseBeenShown = true;
    });
  }

  Future<void> _saveShowcaseStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('textingShowcase', true);
  }

  // Function to scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  final List<String> emojis = ['🙂', '🥰', '🥺', '😈'];
  String selectedEmoji = '🙂';

  void _showEmojiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Select Emoji'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures the column takes up only the necessary space
            children: [
              Wrap(
                alignment: WrapAlignment
                    .center, // Aligns all the children in the center
                spacing: 10.0, // Spacing between emojis
                children: emojis.map((emoji) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedEmoji = emoji; // Update selectedEmoji
                          // _messageController.text += emoji;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  File? _selectedImage; // To store the selected image

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  // key: _listViewKey,
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shrinkWrap: true,
                  itemCount: widget.controllers.messages
                      .length, // Access from widget.controllers
                  itemBuilder: (context, index) {
                    final message = widget.controllers.messages[index];
                    return ChatBubble(
                      imageUrl: message.imageUrl,
                      text: message.text,
                      isSender: message.isSender,
                      messageType: message.messageType,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15,
                right: 10.w,
                left: 10.w,
              ),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Showcase(
                    key: _attachFiles,
                    title: "Add a chats Screenshot of your crush 💬 ",
                    overlayOpacity: .5,
                    tooltipBackgroundColor: AppPallete.chatScreenPrimary,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    description: "Let's make your crush fall for you 💖",
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black12,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.attach_file_rounded,
                            size: 25.w,
                          ),
                          onPressed: _selectImage,
                        ),
                      ),
                    ),
                  ),

                  Showcase(
                    key: _addEmoji,
                    title:
                        "Add emoji the type of reply you want from your crush💬 ",
                    overlayOpacity: .5,
                    tooltipBackgroundColor: AppPallete.chatScreenPrimary,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    description: "Decide the emotion in the repky you want 💖",
                    child: GestureDetector(
                      onTap: () {
                        _showEmojiDialog(context); // Show emoji dialog on tap
                      },
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black12,
                        ),
                        child: Center(
                          child: Text(
                            selectedEmoji, // Display selectedEmoji
                            style: TextStyle(fontSize: 25.sp),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //add a emoji picker for as shown in the image

                  Flexible(
                    child: Container(
                      // width: Get.width - 250.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black12,
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          fillColor: AppPallete.backgroundColor.withOpacity(.5),
                          contentPadding: const EdgeInsets.all(15),
                          hintText: "Type your message here",
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800,
                          ),
                          border: InputBorder.none,
                          suffixIcon: Showcase(
                            key: _send,
                            title: "Just Hit Send ",
                            overlayOpacity: .5,
                            tooltipBackgroundColor:
                                AppPallete.chatScreenPrimary,
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                            description:
                                "Harness the magic of Virtual Love Guru 💖",
                            child: IconButton(
                              icon: _isLoading
                                  ? CircularProgressIndicator()
                                  : Icon(Icons.send_rounded),
                              onPressed: () async {
                                if (_messageController.text.isNotEmpty ||
                                    _selectedImage != null) {
                                  setState(() {
                                    _isLoading = true; // Show loading indicator
                                  });

                                  bool success =
                                      await widget.controllers.sendMessage(
                                    _messageController.text,
                                    imageFile: _selectedImage,
                                    emoji:
                                        selectedEmoji, // Pass the selected emoji
                                  );

                                  // Scroll to the bottom using the ListView's key
                                  _scrollToBottom();

                                  _messageController.clear();

                                  if (mounted) {
                                    setState(() {
                                      _isLoading = !success;
                                      _selectedImage = null;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
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
    );
  }
}
