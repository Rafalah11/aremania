import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { successful, unsuccessful }

class AuthExceptionHandler {
  static handleAuthException(e) {
    // Implementasikan logika penanganan error di sini
    // Contoh sederhana:
    print("Auth Error: $e");
    return AuthStatus.unsuccessful;
  }
}

class UbahKataSandiController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable untuk menghitung jumlah
  final count = 0.obs;

  // Fungsi reset password
  Future<AuthStatus> resetPassword({required String email}) async {
    AuthStatus _status = AuthStatus.unsuccessful;
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }
}
