import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
    static Future goToWebPage(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}