// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatSettingsChips extends StatelessWidget {
  String label;
  List<String> options;

  ChatSettingsChips({
    super.key,
    required this.label,
    required this.options,
  });
  final ChatControllers controller = Get.find<ChatControllers>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18.sp)),
        Obx(
          () => Wrap(
            spacing: 8.0.w,
            children: options.map((option) {
              return ChoiceChip(
                showCheckmark: false,
                label: Text(option),
                // shape: OvalBorder(eccentricity:1, side:BorderSide(color: AppPallete.chatScreenPrimary,),),
                side: BorderSide(
                  color: controller.selectedChips.contains(option)
                      ? AppPallete.chatScreenPrimary
                      : AppPallete.transparentColor,
                  width: controller.selectedChips.contains(option) ? 2 : 0,
                ),
                selected: controller.selectedChips.contains(option),
                onSelected: (bool selected) {
                  controller.toggleChipSelection(option);
                },
                disabledColor: AppPallete.chipsColor.withOpacity(.1),
                backgroundColor:
                    AppPallete.homeScreenBackgroundColor.withOpacity(.50),
                selectedColor: AppPallete.chipsColor.withOpacity(.09),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
