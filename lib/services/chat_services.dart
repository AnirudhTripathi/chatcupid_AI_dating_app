import 'dart:convert';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openai_dart/openai_dart.dart';
import 'package:vertex_ai/vertex_ai.dart';
import 'package:googleapis_auth/auth_io.dart';



class ChatService {
  static String _apiKey =
      'sk-z97b8WXUTaPkmqGrZTMiC6O64q7amGZjsxw40jPuNmT3BlbkFJXnXT9emYWGvJ6CX9toNe_4qERjni8xrUScjN66GfgA';

  final OpenAIClient client = OpenAIClient(apiKey: _apiKey);

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  Future<String> sendMessage(String message, [String? persona]) async {
    try {
      String prompt = persona != null
          ? "You are an AI assistant named ${persona}. Your role is to have a friendly, empathetic conversation with the user, providing thoughtful and engaging responses. Tailor your personality and tone to the relationship context they've provided."
          : "You are a replica of the ${onboardingController.userName.value}!'s self, designed to help them explore their inner thoughts and emotions. Engage with thoughtful questions that guide the user toward self-reflection, encouraging them to better understand their feelings, habits, and personal growth. Instead of offering direct advice, prompt the user to uncover insights and patterns on their own, fostering a deeper connection with themselves and promoting emotional well-being.";

      final res = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(content: prompt),
            ChatCompletionMessage.user(
                content: ChatCompletionUserMessageContent.string("$message"))
          ],
          maxTokens: 1024,
          temperature: 0.7,
        ),
      );

      final generatedText = res.choices.first.message.content;
      print("$generatedText");
      return generatedText!;
    } catch (e) {
      print('Error sending message: $e');
      return 'An error occurred';
    }
  }
}
