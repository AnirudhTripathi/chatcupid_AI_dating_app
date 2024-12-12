import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApiService {
  final String _apiUrl =
      'https://us-central1-chatcupid-87b76.cloudfunctions.net/generateReply';

  Future<Map<String, dynamic>?> generateReply(
      Map<String, dynamic> requestBody) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print("$response");
  


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error generating reply: $e');
      return null;
    }
  }
}
