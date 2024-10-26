import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var isLoggedIn = false.obs;

  // Method untuk memeriksa status login
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('token') != null; // Cek keberadaan token
  }
}
