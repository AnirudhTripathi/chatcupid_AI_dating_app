import 'package:chatcupid/services/auth_services.dart';
import 'package:http/http.dart' as http;

class RizzResponse {
  Future<void> AiResponse() async {
    String? x = await AuthService.getIdToken();

    final response = await http.post(
      Uri.parse(
          "https://us-central1-chatcupid-87b76.cloudfunctions.net/getCuteMessage"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${x}',
      },
      body: {
        "image": "image_URL",
        "texts": ["Hello", "World"]
      },
    );

    if (response.statusCode == 200) {
      throw Exception('Success to fetch ');
    } else {
      throw Exception('Failed to fetch ');
    }
  }
}
