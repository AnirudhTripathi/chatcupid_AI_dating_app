import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/screens/auth_screens/login_screen.dart';
import 'package:chatcupid/screens/chat_screens/chat_screen.dart';
import 'package:chatcupid/screens/chat_screens/chat_setting.dart';
import 'package:chatcupid/screens/chat_screens/me_section_texting_screen.dart';
import 'package:chatcupid/screens/chat_screens/texting_screen.dart';
import 'package:chatcupid/screens/home_screens/widgets/custom_floating_navbar.dart';

import 'package:chatcupid/screens/onboarding_screens/first_onboarding_screen.dart';
import 'package:chatcupid/screens/onboarding_screens/initial_onboarding_screen.dart';
import 'package:chatcupid/screens/onboarding_screens/second_onboarding_screem.dart';
import 'package:chatcupid/screens/onboarding_screens/third_onboarding_screen.dart';
import 'package:chatcupid/screens/settings_screen/profile_screen.dart';
import 'package:chatcupid/screens/splash_screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class RoutesHelper {
  static const String splashScreen = "/splash-screen";
  static const String initialOnboardingScreen = "/initial-onboarding-screen";
  static const String loginScreen = "/login-in-screen";
  static const String firstOnboardingScreen = "/first-onboarding-screen";
  static const String secondOnboardingScreen = "/second-onboarding-screen";
  static const String thirdOnboardingScreen = "/third-onboarding-screen";
  static const String bottomNavbar = "/bottom-navbar";
  static const String chatScreen = "/chat-screen";
  static const String chatScreenSetting = "/chat-screen-setting";
  static const String profileScreenSetting = "/profile-screen-setting";
  static const String textingScreen = "/texting-screen";
  static const String meSectionTextingScreen = "/me-section-texting-screen";

  static String getSplashScreen() => splashScreen;
  static String getinitialOnboardingScreen() => initialOnboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getFirstOnboardingScreen() => firstOnboardingScreen;
  static String getSecondOnboardingScreen() => secondOnboardingScreen;
  static String getThirdOnboardingScreen() => thirdOnboardingScreen;
  static String getBottomNavbar() => bottomNavbar;
  static String getchatScreen(String name) => '$chatScreen?name=$name';
  static String getchatScreenSetting() => chatScreenSetting;
  static String getProfileScreenSetting() => profileScreenSetting;
  static String getTextingScreen(ChatControllers controllers) =>
      textingScreen; // Remove query parameter
  static String getMeSectionTextingScreen(ChatControllers controllers) =>
      meSectionTextingScreen; // Remove query parameter

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: initialOnboardingScreen,
      page: () => const InitialOnboardingScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: firstOnboardingScreen,
      page: () => FirstOnboardingScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: secondOnboardingScreen,
      page: () => const SecondOnboardingScreem(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: thirdOnboardingScreen,
      page: () => ThirdOnboardingScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: bottomNavbar,
      page: () => const CustomFloatingNavbar(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: chatScreen,
      page: () {
        var name = Get.parameters['name'];
        return ChatScreen(name: name!);
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: chatScreenSetting,
      page: () => const ChatSettingsScreen(
        chatId: 'Chatcupid123',
      ),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      arguments: {'chatId': 'yourChatId'},
    ),
    GetPage(
      name: profileScreenSetting,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: textingScreen,
      page: () {
        final controllers = Get.put(
          ChatControllers(),
          // Use persona's name as tag
        );
        return TextingScreen(
          controllers: controllers, // Pass controllers to TextingScreen
        );
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: meSectionTextingScreen,
      page: () {
        final controllers = Get.put(
          ChatControllers(),
          // Use persona's name as tag
        );
        return MeSectionTextingScreen(
          controllers: controllers, // Pass controllers to TextingScreen
        );
      },
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
