import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/controllers/purchase_controllers.dart';
import 'package:chatcupid/controllers/streak_controllers.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/screens/purchase_screens/purchase_card.dart';
import 'package:chatcupid/screens/purchase_screens/purchase_info_card.dart';
import 'package:chatcupid/screens/purchase_screens/refer_promotion_card.dart';
import 'package:chatcupid/screens/purchase_screens/widgets/buy_button.dart';
import 'package:chatcupid/screens/purchase_screens/widgets/refer_button.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({super.key});
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();
  final StreakControllers streakControllers = Get.find<StreakControllers>();

  final PurchaseControllers purchaseControllers =
      Get.put(PurchaseControllers());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (purchaseControllers.purchaseShowShowcase.value) {
        ShowCaseWidget.of(context)
            .startShowCase(purchaseControllers.showcaseKeys);
        purchaseControllers.setShowcaseStatus(false);
      }
    });

    return Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        onPressed: () {
          Get.toNamed(RoutesHelper.profileScreenSetting);
        },
        profileIcon: onboardingController.userProfilePic.value,
        text: onboardingController.userName.value.isNotEmpty
            ? onboardingController.userName.value
                .split(' ')[0]
            : "SuperCupid",
        textSize: 25.sp,
        hiText: true,
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 110.0.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => PurchaseInfoCard(
                        iconPath: CustomIcons.streakPurchase,
                        value: '${streakControllers.currentStreak.value} days',
                        description: 'Streak',
                      ),
                    ),
                    PurchaseInfoCard(
                      iconPath: CustomIcons.totalEarned,
                      value: '₹00',
                      description: 'Total Earnings',
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Showcase(
                  key: purchaseControllers.showcaseKeys[0],
                  title: "Unlock more with ChatCupid! 🎁 ",
                  overlayOpacity: .5,
                  tooltipBackgroundColor: AppPallete.chatScreenPrimary,
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  description:
                      "Earn cash rewards by referring friends or get premium access for unlimited messaging. You’ve got 3 free messages daily—after that, go premium or share the app to keep the conversation going. More love, more fun!",
                  child: ReferButton(
                    title: "Refer and earn real cash💸",
                  ),
                ),

                SizedBox(height: 20.h),

                BuyButton(),

                SizedBox(height: 20.h),
                ReferButton(
                  title: 'You are on a Monthly Free plan',
                ),
                // Spacer(),
              ],
            ),
          ),
          // Positioned(
          //   top: 400.h,
          //   child: ReferPromotionCard(),
          // ),
        ],
      ),
    );
  }
}
