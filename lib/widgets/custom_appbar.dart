import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/services/auth_services.dart';
import 'package:chatcupid/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_status_service.dart';
// import 'package:flutter_svg/svg.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool backButton;
  final bool hiText;
  final bool appbarIcon;
  final bool saveIcon;
  final bool showProfile;
  final VoidCallback? onPressed;
  final String? profileIcon;
  final double textSize;

  CustomAppbar({
    super.key,
    required this.text,
    this.backButton = false,
    this.hiText = false,
    this.appbarIcon = true,
    this.saveIcon = false,
    this.showProfile = true,
    this.profileIcon,
    this.onPressed,
    required this.textSize,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);
  final authStatusService = Get.find<AuthStatusService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 5.h,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (backButton) ...[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50.w,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppPallete.backgroundColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 20.w,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
                if (hiText)
                  GradientText(
                    gradientText: "Hi, ",
                    size: textSize,
                  ),
                GradientText(
                  gradientText: text,
                  size: textSize,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showProfile) ...[
                      GestureDetector(
                        onTap: onPressed,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(profileIcon!),
                        ),
                      ),
                    ],
                    SizedBox(
                      width: 5.w,
                    ),
                    if (appbarIcon) ...[
                      IconButton(
                        icon: Image.asset(
                          "assets/images/whatsapp_image.png",
                          width: 45.w,
                          height: 45.w,
                        ),
                        tooltip: 'Comment Icon',
                        onPressed: () async {
                          await AuthService.getIdToken();
                          await goToWhatsApp(
                              "+91 8406082447", "Hello! I'm using ChatCupid.");

                          // if (await FlutterOverlayWindow.isActive()) return;
                          // await FlutterOverlayWindow.showOverlay(
                          //   enableDrag: true,
                          //   overlayTitle: "X-SLAYER",
                          //   overlayContent: 'Overlay Enabled',
                          //   flag: OverlayFlag.defaultFlag,
                          //   visibility: NotificationVisibility.visibilityPublic,
                          //   positionGravity: PositionGravity.auto,
                          //   height: 500.h.toInt(),
                          //   width: 500.w.toInt(),
                          //   startPosition: const OverlayPosition(0, -20),
                          // );
                        },
                      ),
                    ],
                    if (saveIcon) ...[
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                        ),
                      ),
                    ],
                  ], //<Widget>[],)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> goToWhatsApp(String phoneNumber, String message) async {
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (!await launchUrl(whatsappUrl)) {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
