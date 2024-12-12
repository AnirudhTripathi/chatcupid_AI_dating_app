import 'package:chatcupid/helpers/init_dependancy.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStatusService extends GetxService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static RxString userName = ''.obs; 

  Future<AuthStatusService> init() async {
     await getUserName(); 
    await checkLoginStatus();
      //  await getUserName();
    return this;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('userName');

    if (storedName != null) {
      userName.value = storedName;
    }
    return userName.value; 
  }

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoginStatus(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }
}
