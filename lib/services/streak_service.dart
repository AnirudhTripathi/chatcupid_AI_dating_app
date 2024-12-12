import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _kLastLoginDateKey = 'lastLoginDate';
  static const String _kCurrentStreakKey = 'currentStreak';

  Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kCurrentStreakKey) ?? 0;
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginDate = prefs.getString(_kLastLoginDateKey);

    final today = DateTime.now().toString().substring(0, 10);

    if (lastLoginDate == today) {
      return;
    }

    if (lastLoginDate != null && _isConsecutiveDay(lastLoginDate, today)) {
      final currentStreak = prefs.getInt(_kCurrentStreakKey) ?? 0;
      await prefs.setInt(_kCurrentStreakKey, currentStreak + 1);
    } else {
      await prefs.setInt(_kCurrentStreakKey, 1);
    }

    await prefs.setString(_kLastLoginDateKey, today);
  }

  bool _isConsecutiveDay(String lastLoginDate, String today) {
    final lastDate = DateTime.parse(lastLoginDate);
    final currentDate = DateTime.parse(today);
    return currentDate.difference(lastDate).inDays == 1;
  }
}
