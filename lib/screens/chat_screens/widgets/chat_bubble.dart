import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String? imageUrl;
  final String? messageType;

  const ChatBubble({
    required this.text,
    required this.isSender,
    this.imageUrl,
    this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl!,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return Icon(Icons.error);
                },
              ),
            ),
          Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: IntrinsicWidth(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSender
                              ? AppPallete.backgroundColor
                              : AppPallete.chatScreenPrimary,
                          borderRadius: BorderRadius.only(
                            topLeft: isSender
                                ? const Radius.circular(20)
                                : const Radius.circular(0),
                            topRight: isSender
                                ? const Radius.circular(0)
                                : const Radius.circular(20),
                            bottomLeft: const Radius.circular(20),
                            bottomRight: const Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          messageType != null ? "\n $text" : text,
                          style: const TextStyle(color: AppPallete.whiteColor),
                        ),
                      ),
                      if (messageType != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 118.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            margin: EdgeInsets.only(bottom: 4.h), // Add margin
                            decoration: BoxDecoration(
                              color: messageType == "Suggested"
                                  ? const Color(
                                      0xFFFF56A5) // Pink color for "Suggested"
                                  : const Color.fromARGB(255, 250, 250,
                                      250), // Purple color for "Decode Convo"
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.layers_outlined,
                                  color: const Color(0xFFFF56A5),
                                  size: 18.sp,
                                ),
                                Text(
                                  messageType == "decodeConvo"
                                      ? "Decode Convo"
                                      : "Suggested",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF56A5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isSender) // Show copy icon only for received messages
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    // Make the icon tappable
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: text));
                      // Optionally, show a snackbar or toast to indicate copied
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Text copied!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white38.withOpacity(
                          .2,
                        ), // Semi-transparent white background
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.copy,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
