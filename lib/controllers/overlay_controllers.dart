import 'package:chatcupid/services/chat_api_setting.dart';
import 'package:get/get.dart';

class OverlayControllers extends GetxController {
  RxInt selectedIndex = 0.obs;

  final ChatApiService _chatApiService =
      ChatApiService(); // Create API service instance
  RxMap<String, dynamic> replyData =
      <String, dynamic>{}.obs; // Store API response
  RxBool isLoading = false.obs;

  void updateSelectedIndex(int newIndex) {
    selectedIndex.value = newIndex;
  }

  Future<void> sendChatData(String? emoji, String context) async {
    isLoading.value = true; // Start loading

    // Create the request body
    Map<String, dynamic> requestBody = {
      "message": "Hello",
      "screenshot": "url",
      "mood": {
        "mood": emojiToMood(emoji), 
        "context": context,
      },
      "chatID": "1",
    };

    final response = await _chatApiService.generateReply(requestBody);

    if (response != null) {
      replyData.value = response;
    }

    isLoading.value = false; 
  }


  String emojiToMood(String? emoji) {
    switch (emoji) {
      case '🙂':
        return 'happy';
      case '🥰':
        return 'loving';
      case '🥺':
        return 'sad';
      case '😈':
        return 'evil';
      default:
        return 'neutral';
    }
  }
}
