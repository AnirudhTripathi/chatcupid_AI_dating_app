class ChatSettings {
  final bool isAutoMode;
  final String application;
  final String firstConnectedOn;
  final String interactionFrequency;
  final String gender;
  final String dateOfBirth;
  final List<String> tone;
  final List<String> context;
  final List<String> expectations;
  final String customContext;

  ChatSettings({
    required this.isAutoMode,
    required this.application,
    required this.firstConnectedOn,
    required this.interactionFrequency,
    required this.gender,
    required this.dateOfBirth,
    required this.tone,
    required this.context,
    required this.expectations,
    required this.customContext,
  });

  // Method to convert ChatSettings to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'isAutoMode': isAutoMode,
      'application': application,
      'firstConnectedOn': firstConnectedOn,
      'interactionFrequency': interactionFrequency,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'tone': tone,
      'context': context,
      'expectations': expectations,
      'customContext': customContext,
    };
  }
}