import 'package:chatcupid/services/streak_service.dart';
import 'package:get/get.dart';

class StreakControllers extends GetxController {
  final StreakService _streakService = StreakService();
  RxInt currentStreak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStreak(); // Load the streak when the controller is initialized
  }

  Future<void> _loadStreak() async {
    currentStreak.value = await _streakService.getCurrentStreak();
  }

  // Call this function when the user opens the home screen
  Future<void> onHomeScreenOpened() async {
    await _streakService.updateStreak();
    await _loadStreak();
  }
}
