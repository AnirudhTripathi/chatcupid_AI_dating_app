import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/like_screen_controller.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/screens/like_screens/widgets/like_screen_card.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class LikeScreen extends StatelessWidget {
  LikeScreen({Key? key}) : super(key: key);

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  final LikeController likeScreenController = Get.put(LikeController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (likeScreenController.shouldShowShowcase.value) {
        ShowCaseWidget.of(context)
            .startShowCase(likeScreenController.showcaseKeys);
      }
    });

    return
        // ShowCaseWidget(
        //   onStart: (index, key) {
        //     print('Showcase started at index: $index');
        //   },
        //   onComplete: (index, key) {
        //     print('Showcase completed at index: $index');
        //     if (index == likeScreenController.showcaseKeys.length - 1) {
        //       likeScreenController.setShowcaseStatus(false);
        //     }
        //   },
        //   builder: (context) =>
        Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        profileIcon: onboardingController.userProfilePic.value,
        onPressed: () {
          Get.toNamed(RoutesHelper.profileScreenSetting);
        },
        text: onboardingController.userName.value.isNotEmpty
            ? onboardingController.userName.value
                .split(' ')[0] // Display user name if available
            : "SuperCupid",
        textSize: 25.sp,
        hiText: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  textAlign: TextAlign.center,
                  "Daily dose of romance!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.h),
              //   child: Showcase(
              //     key: likeScreenController.showcaseKeys[0],
              //     description: "Explore your daily dose of romance!",
              //     child: Text(
              //       "Daily dose of romance!",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20.sp,
              //         fontWeight: FontWeight.normal,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  if (likeScreenController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (likeScreenController.filteredPosts.isEmpty) {
                    return Center(
                      child: Text(
                        'No posts available yet',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15.h,
                        ),
                        itemCount:
                            likeScreenController.filteredPosts.length + 1,
                        itemBuilder: (context, index) {
                          if (index <
                              likeScreenController.filteredPosts.length) {
                            final post =
                                likeScreenController.filteredPosts[index];
                            final postData =
                                post.data() as Map<String, dynamic>;
                            final imageUrl = postData['imageURL'] as String;
                            final description =
                                postData['description'] as String?;

                            final likeController = Get.put(
                                LikeController(postId: post.id),
                                tag: post.id);

                            if (index == 0) {
                              return Showcase(
                                key: likeScreenController.showcaseKeys[0],
                                title: "Explore ME section! 💬 ",
                                overlayOpacity: .5,
                                tooltipBackgroundColor:
                                    AppPallete.chatScreenPrimary,
                                textColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                description:
                                    "In ME section you can find the better version of your self 💖",
                                child: LikeCard(
                                  imageUrl: imageUrl,
                                  description: description ?? '',
                                  likeController: likeController,
                                ),
                              );
                            } else {
                              return LikeCard(
                                imageUrl: imageUrl,
                                description: description ?? '',
                                likeController: likeController,
                              );
                            }
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50.h),
                                SizedBox(
                                  height: 200.h,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30.w),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "That's all\nfor Today\n",
                                            style: TextStyle(
                                              fontSize: 35.sp,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "\nMade with ❤️ for all lovers ",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 100.h),
                              ],
                            );
                          }
                        });
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
