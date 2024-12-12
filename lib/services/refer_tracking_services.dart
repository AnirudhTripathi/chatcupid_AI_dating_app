import 'package:android_play_install_referrer/android_play_install_referrer.dart';

class ReferralTracker {
  static Future<void> checkAndProcessReferral() async {
    try {
      AndroidPlayInstallReferrer referrerPlugin = AndroidPlayInstallReferrer();
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      if (referrerDetails.installReferrer != null &&
          referrerDetails.installReferrer!.isNotEmpty) {
        // Parse the referrer data
        Uri referrerUri = Uri.parse(referrerDetails.installReferrer!);
        String? referrerId = referrerUri.queryParameters['user_id'];

        if (referrerId != null) {
          // Process the referral
          await _processReferral(referrerId, referrerDetails);
        }
      }
    } catch (e) {
      print("Error checking referral: $e");
    }
  }

  static Future<void> _processReferral(
      String referrerId, ReferrerDetails details) async {
    // Implement your referral processing logic here
    print("Processing referral from user: $referrerId");
    // print("Referrer app version: ${details.referrerAppVersion}");
    print("Install begin timestamp: ${details.installBeginTimestampSeconds}");
    print("Referrer click timestamp: ${details.referrerClickTimestampSeconds}");

    // Add code here to award coins or update user stats
    // This might involve making API calls to your backend
    // or updating local storage
  }
}
