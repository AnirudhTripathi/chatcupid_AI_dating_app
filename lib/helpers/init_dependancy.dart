import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/controllers/like_screen_controller.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/controllers/overlay_controllers.dart';
import 'package:chatcupid/controllers/streak_controllers.dart';
import 'package:chatcupid/services/auth_status_service.dart';
import 'package:get/get.dart';

class InitDependancy {
  static void onInit() async {
    await Get.putAsync(() => AuthStatusService().init());
    // Get.put(ChatControllers(),permanent: true);
    // Get.put(ChatControllers());
    //  await Get.putAsync(() => UserService().init());
    // Get.put(LikeController());
    
    Get.put(OverlayControllers());
    Get.put(StreakControllers());
    Get.put(OnboardingController());
  // Get.lazyPut(() => ChatControllers(personaName: 'init'));
  }
}
