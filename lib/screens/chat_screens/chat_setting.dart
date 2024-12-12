import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/models/chat_settings.dart';
import 'package:chatcupid/screens/chat_screens/widgets/chat_settings_chips.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatSettingsScreen extends StatefulWidget {
  final String chatId;

  const ChatSettingsScreen({Key? key, required this.chatId}) : super(key: key);
  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  final bool status = true;
  bool isAutoMode = true;
  String? selectedApplication = 'Whatsapp';
  TextEditingController firstConnectedOnController = TextEditingController();
  TextEditingController interactionFrequencyController =
      TextEditingController();
  String? selectedGender = 'Male';
  TextEditingController dateOfBirthController = TextEditingController();
  List<String> selectedTones = ['Flirty'];
  List<String> selectedContexts = ['First meeting'];
  List<String> selectedExpectations = ['Long term'];
  TextEditingController customContextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shrinkWrap: true,
            children: [
              Container(
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 0.5.w),
                    Text(
                      'Mode',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    const Icon(Icons.info_outline),
                    SizedBox(width: 100.w),
                    Row(
                      children: [
                        Text('Auto', style: TextStyle(fontSize: 18.sp)),
                        SizedBox(width: 10.w),
                        Switch(
                          value: status,
                          activeColor: AppPallete.whiteColor,
                          activeTrackColor: AppPallete.primaryColor,
                          onChanged: (value) {
                            status;
                          },
                        ),
                        SizedBox(width: 8.w),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: 'Application                          ',
                      prefixStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                      ),
                    ),
                    value: 'Whatsapp',
                    items: <String>['Whatsapp', 'Facebook', 'Instagram']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 00.h),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'First connected on',
                          labelStyle: TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Frequency of interactions",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            "12 times a day",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppPallete.blackColor.withOpacity(.25),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.w, top: 8.h),
                          border: InputBorder.none,
                        ),
                        value: 'Male',
                        items: <String>['Male', 'Female', 'Other']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppPallete.blackColor.withOpacity(.25),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          labelText: 'dd/mm/yy',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ChatSettingsChips(
                    label: 'Tone',
                    options: const [
                      'Flirty',
                      'Funny',
                      'Playful',
                      'Cute',
                      'Serious',
                      'Casual',
                      'Witty',
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ChatSettingsChips(
                    label: 'Context',
                    options: const [
                      'Reviving a conversation',
                      'First meeting',
                      'Casual chat',
                      'Planning a date'
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ChatSettingsChips(
                    label: 'Expectations',
                    options: const [
                      'Short term',
                      'Long term',
                      'Casual dating',
                      'Friend'
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.blackColor.withOpacity(.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Custom context"),
                      SizedBox(
                        height: 15.w,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppPallete.homeScreenBackgroundColor
                              .withOpacity(.50),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'type your context here...',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              AuthButton(
                buttonText: "Save",
                onPressed: () {
                  ChatSettings chatSettings = ChatSettings(
                    isAutoMode: isAutoMode,
                    application: selectedApplication ?? 'Whatsapp',
                    firstConnectedOn: firstConnectedOnController.text,
                    interactionFrequency: interactionFrequencyController.text,
                    gender: selectedGender ?? 'Male',
                    dateOfBirth: dateOfBirthController.text,
                    tone: selectedTones,
                    context: selectedContexts,
                    expectations: selectedExpectations,
                    customContext: customContextController.text,
                  );
                  _saveChatSettingsToFirestore(widget.chatId, chatSettings);
                },
                buttonTextColor: AppPallete.blackColor,
                backgroundColor: AppPallete.whiteColor,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _saveChatSettingsToFirestore(
    String chatId, ChatSettings settings) async {
  try {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('settings')
        .doc('userSettings')
        .set(settings.toMap());

    print('Chat settings saved successfully!');
  } catch (e) {
    print('Error saving chat settings: $e');
  }
}
