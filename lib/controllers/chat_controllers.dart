import 'dart:io';

import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/models/chat_message.dart';
import 'package:chatcupid/services/chat_api_setting.dart';
import 'package:chatcupid/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatControllers extends GetxController {
  RxInt selectedIndex = 0.obs;
  final RxList<String> selectedChips = <String>[].obs;
  final ChatService _chatService = ChatService();
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  late final String? personaName; // Add personaName
  late final String? userId;
  // var now = DateTime.now();

  final ChatApiService _chatApiService = ChatApiService();

  ChatControllers({this.personaName}) {
    userId = FirebaseAuth.instance.currentUser?.uid;
    // Fetch messages when the controller is created
    fetchMessages();
  }

//  Future<void> sendMessage(String message, {bool isMeSection = false}) async {
//     if (userId == null) {
//       print("User not logged in!");
//       return;
//     }

//     final newMessage = ChatMessage(text: message, isSender: true);
//     messages.add(newMessage);

//     // Send message to chatbot (if not "me_section")

//     // Save the message to the correct location in Firestore
//     if (isMeSection) {
//       _saveMessageToMeSection(newMessage);
//     } else {
//       _saveMessageToFirebase(newMessage);
//     }
//   }

  Future<bool> _wasIntroMessageSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('meSectionIntroSent') ?? false;
  }

  // Function to mark the intro message as sent
  Future<void> _setIntroMessageSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('meSectionIntroSent', true);
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
        return 'playful';
      default:
        return 'happy';
    }
  }

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  @override
  void onInit() {
    super.onInit();
    _sendIntroMessageIfNeeded();
  }

  Future<void> _sendIntroMessageIfNeeded() async {
    if (userId != null && !(await _wasIntroMessageSent())) {
      final introMessage = ChatMessage(
        text:
            "Hello ${onboardingController.userName.value}! My purpose is to help you deepen your connection with yourself, and the people or things you love. Whether you want to talk about your relationship with yourself, learn more about your emotional patterns, or get tips for healthy relationships, I'm here to support you. What would you like to start with?",
        isSender: false, // Message from the chatbot
      );

      messages.add(introMessage);
      _saveMessageToMeSection(introMessage);
      _setIntroMessageSent(); // Mark the intro message as sent
    }
  }
  // Future<void> sendMessage(
  //   String message, {
  //   bool isMeSection = false,
  //   File? imageFile,
  //   String? emoji,
  // }) async {
  //   if (userId == null) {
  //     print("User not logged in!");
  //     return;
  //   }

  //   String? imageUrl;
  //   if (imageFile != null) {
  //     imageUrl = await _uploadImageToFirebase(imageFile);
  //   }

  //   final newMessage = ChatMessage(
  //     text: message,
  //     isSender: true,
  //   );
  //   messages.add(newMessage);

  //   // Get the chatbot's response (for both me_section and persona chats)
  //   // final response = await _chatService.sendMessage(message, personaName);
  //   // messages.add(ChatMessage(text: response, isSender: false));

  //   String responseText;

  //   if (imageFile != null && emoji != null) {
  //     final requestBody = {
  //       "message": "What should be my next reply",
  //       "screenshot": imageUrl,
  //       "mood": {
  //         "mood": emojiToMood(emoji),
  //         "context": "What should be my next reply",
  //       },
  //       "chatID": userId!
  //     };

  //     final response = await _chatApiService.generateReply(requestBody);

  //     // Extract the reply string from the response map
  //     responseText = response?['reply']['reply1'] ?? 'No reply from API';

  //   } else {
  //     // Only text, call normal sendMessage
  //     responseText = await _chatService.sendMessage(message, personaName);
  //     messages.add(ChatMessage(text: responseText, isSender: false));
  //   }

  //   // Add the response to messages
  //   // messages.add(ChatMessage(text: responseText, isSender: false));

  //   // Save messages to Firebase based on isMeSection
  //   if (isMeSection) {
  //     _saveMessageToMeSection(newMessage);
  //     _saveMessageToMeSection(ChatMessage(text: responseText, isSender: false));
  //   } else {
  //     _saveMessageToFirebase(newMessage);
  //     _saveMessageToFirebase(ChatMessage(text: responseText, isSender: false));
  //   }
  // }

  String _saveSeconds(int second) {
    var modifiedTime = DateTime.now().add(Duration(seconds: second));
    var formattedTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(modifiedTime); // ISO 8601 format
    return formattedTime;
  }

  Future<bool> sendMessage(
    String message, {
    bool isMeSection = false,
    File? imageFile,
    String? emoji,
  }) async {
    if (userId == null) {
      print("User not logged in!");
      return false;
    }
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImageToFirebase(imageFile);
      }

      String? responseText;
      String responseText2;

      if (imageFile != null && emoji != null) {
        final requestBody = {
          "message": "What should be my next reply",
          "screenshot": imageUrl,
          "mood": emojiToMood(emoji),
        };
        final response = await _chatApiService.generateReply(requestBody);

        responseText = response?['reply']['reply1'] ?? 'No reply from API';
        responseText2 = response?['reply']['reply2'] ?? 'No reply from API';
        String decodeConvoText =
            response?['reply']['decode_convo'] ?? 'No decode convo from API';

        //  int seconds;

        // Add the special message and image to messages list
        messages.add(ChatMessage(
          text: "What should be my next reply",
          isSender: true,
          imageUrl: imageUrl,
        ));
        messages.add(ChatMessage(
          text: responseText!,
          isSender: false,
          messageType: "suggested", // Add a message type for "Suggested"
          // timestamp: _saveSeconds(1),
        ));
        messages.add(ChatMessage(
          text: responseText2,
          isSender: false,
          messageType: "suggested2", // Add a message type for "Suggested"
          // timestamp: _saveSeconds(2),
        ));
        messages.add(ChatMessage(
          text: decodeConvoText,
          isSender: false,
          messageType: "decodeConvo", // Add a message type for "Decode Convo"
          // timestamp: _saveSeconds(3),
        ));

        // Save the messages to Firebase
        if (isMeSection) {
          _saveMessageToMeSection(ChatMessage(
            text: "What should be my next reply",
            isSender: true,
            imageUrl: imageUrl,
          ));
          _saveMessageToMeSection(ChatMessage(
            text: responseText,
            isSender: false,
            messageType: "suggested",
          ));
          _saveMessageToMeSection(ChatMessage(
            text: decodeConvoText,
            isSender: false,
            messageType: "decodeConvo",
          ));
        } else {
          _saveMessageToFirebase(ChatMessage(
            text: "What should be my next reply",
            isSender: true,
            imageUrl: imageUrl,
          ));
          _saveMessageToFirebase(ChatMessage(
            text: responseText,
            isSender: false,
            messageType: "suggested",
            timestamp: _saveSeconds(0),
          ));
          _saveMessageToFirebase(ChatMessage(
            text: responseText2,
            isSender: false,
            messageType: "suggested2",
            timestamp: _saveSeconds(0),
          ));
          _saveMessageToFirebase(ChatMessage(
            text: decodeConvoText,
            isSender: false,
            messageType: "decodeConvo",
            timestamp: _saveSeconds(0),
          ));
        }
      } else {
        // Handle regular text message
        final newMessage = ChatMessage(
          text: message,
          isSender: true,
        );
        messages.add(newMessage);

        responseText = await _chatService.sendMessage(message, personaName);
        messages.add(ChatMessage(text: responseText, isSender: false));

        if (isMeSection) {
          _saveMessageToMeSection(newMessage);
          _saveMessageToMeSection(
              ChatMessage(text: responseText, isSender: false));
        } else {
          _saveMessageToFirebase(newMessage);
          _saveMessageToFirebase(
              ChatMessage(text: responseText, isSender: false));
        }
      }
      return true;
    } catch (e) {
      print("error $e");
      return false;
    }
  }

  Future<void> _saveMessageToFirebase(ChatMessage message) async {
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('persona_chats')
            .doc(personaName) // Use personaName to identify the document
            .collection('chat_details')
            .add({
          'text': message.text,
          'isSender': message.isSender,
          'imageUrl': message.imageUrl,
          'messageType': message.messageType,
          'timestamp':
              // message.timestamp != null
              //     ? Timestamp.fromDate(DateTime.parse(
              //         message.timestamp!)) // Use custom timestamp if available
              //     :
              FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error saving message to Firebase: $e');
        // Handle error, maybe show a message to the user
      }
    }
  }

  // Function to fetch chat messages from Firebase
  Future<void> fetchMessages() async {
    if (userId != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('persona_chats')
            .doc(personaName)
            .collection('chat_details')
            .orderBy('timestamp') // Order messages by timestamp
            .get();

        messages.assignAll(snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            text: data['text'],
            isSender: data['isSender'],
            imageUrl: data['imageUrl'],
            messageType: data['messageType'],
          );
        }).toList());
      } catch (e) {
        print('Error fetching messages: $e');
        // Handle error
      }
    }
  }

  void toggleChipSelection(String option) {
    if (selectedChips.contains(option)) {
      selectedChips.remove(option);
    } else {
      selectedChips.add(option);
    }
  }

  void addMessage(String message, bool isSender) {
    messages.add(ChatMessage(text: message, isSender: isSender));
  }

  // Future<void> sendMessage(String message) async {
  //   messages.add(ChatMessage(text: message, isSender: true));

  //   // Get the chatbot's response
  //   final response = await _chatService.sendMessage(message);

  //   // Add the chatbot's response to the messages list
  //   messages.add(ChatMessage(text: response, isSender: false));
  // }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> loadChatSettings(String chatId) async {
    try {
      final settingsDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('settings')
          .doc('userSettings')
          .get();

      if (settingsDoc.exists) {}
    } catch (e) {
      print('Error loading chat settings: $e');
    }
  }
//
////////////////////////////////
  ///Me Section
////////////////////////////////
//

  Future<void> _saveMessageToMeSection(ChatMessage message) async {
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('me_section')
            .doc('chat_storage')
            .collection('chat_details')
            .add({
          'text': message.text,
          'isSender': message.isSender,
          'imageUrl': message.imageUrl,
          'messageType': message.messageType,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error saving message to me_section: $e');
      }
    }
  }

  // Method to fetch chat messages from the "me_section" chat
  Future<void> fetchMeSectionMessages() async {
    if (userId != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('me_section')
            .doc('chat_storage')
            .collection('chat_details')
            .orderBy('timestamp')
            .get();

        messages.assignAll(snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            text: data['text'],
            isSender: data['isSender'],
            imageUrl: data['imageUrl'],
            messageType: data['messageType'],
          );
        }).toList());
      } catch (e) {
        print('Error fetching messages from me_section: $e');
      }
    }
  }

  // Update sendMessage to handle both "me_section" and persona chats
}
