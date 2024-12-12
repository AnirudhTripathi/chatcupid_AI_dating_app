import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool isSender;
  final String? imageUrl;
  final String? messageType;
  final String? timestamp; // Add timestamp field

  ChatMessage({
    required this.text,
    required this.isSender,
    this.imageUrl,
    this.messageType,
    this.timestamp, // Include timestamp in constructor
  });
}
