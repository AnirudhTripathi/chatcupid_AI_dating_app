import 'dart:io';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';

import 'package:chatcupid/controllers/like_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeCard extends StatelessWidget {
  final String imageUrl;
  final String description;
  final LikeController likeController;

  const LikeCard({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.likeController,
  });

  @override
  Widget build(BuildContext context) {
    // final LikeController likeController = Get.find<LikeController>();
    return Column(
      children: [
        InkWell(
          onDoubleTap: () {
            likeController.toggleLike();
            // return !isLiked;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 400.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppPallete.homeScreensIconColor.withOpacity(.60),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(9.r),
                  child: Obx(
                    () => LikeButton(
                      size: 35.sp,
                      isLiked: likeController.isLiked.value,
                      onTap: (isLiked) async {
                        likeController.toggleLike();
                        return !isLiked;
                      },
                      circleColor: CircleColor(
                        start: Color(0xff00ddff),
                        end: Color(0xff0099cc),
                      ),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          likeController.isLiked.value
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 35.sp,
                        );
                      },
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked ? Colors.red : Colors.grey;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            "love",
                            style: TextStyle(color: color),
                          );
                        } else
                          result = Text(
                            text,
                            style: TextStyle(color: color),
                          );
                        return result;
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String referralLink = await generateReferralLink();
                  await shareReferralLink(referralLink);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPallete.homeScreensIconColor.withOpacity(.60),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      CustomIcons.shareIcon,
                      width: 35.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            description,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<String> generateReferralLink() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    if (userId.isEmpty) {
      // Generate a unique user ID if not already set
      userId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('user_id', userId);
    }

    // Construct the referral link with the user ID
    String baseUrl =
        "https://play.google.com/store/apps/details?id=com.app.chatcupid";
    String referralLink = "$baseUrl&referrer=user_id%3D$userId";

    return referralLink;
  }

  Future<void> shareReferralLink(String referralLink) async {
    final response = await http.get(Uri.parse("$imageUrl"));

    final directory = await getTemporaryDirectory();

    final file = File("${directory.path}/temp_image.jpg");

    await file.writeAsBytes(response.bodyBytes);

    await Share.shareXFiles([XFile(file.path)],
        text:
            "$description \n\nCheck out new Dating Platform ChatCupid,  Use my referral link to sign up: $referralLink");
  }
}
