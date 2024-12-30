import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
import 'package:myapp/app/modules/halaman_login/views/halaman_login_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NgalamTerbaruController ngalamTerbaruController =
      Get.find<NgalamTerbaruController>(); // Inisialisasi controller
  RxBool isLoading = false.obs;

  Stream<User?> get streamAuthStatus => _auth.authStateChanges();

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kirim email verifikasi
      await userCredential.user?.sendEmailVerification();

      Get.snackbar(
        'Success',
        'Registration successful! Please verify your email before logging in.',
        backgroundColor: Colors.green,
      );

      // Arahkan ke halaman login setelah pendaftaran
      Get.off(HalamanLoginView());
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.emailVerified ?? false) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', 'your_token_value');

        Get.snackbar('Success', 'Login successful',
            backgroundColor: Colors.green);

        // Cek apakah user adalah pengguna baru
        bool isNewUser = prefs.getBool('isNewUser') ?? false;
        if (isNewUser) {
          // Reset flag setelah login berhasil
          await prefs.setBool('isNewUser', false);

          // Langsung arahkan ke halaman homescreen
          Get.offAllNamed(Routes.HOME);
        } else {
          // Panggil loadUserData untuk memuat data pengguna
          final HalamanInformasiPribadiController
              halamanInformasiPribadiController = Get.find();
          await halamanInformasiPribadiController.loadUserData();

          // Jika berhasil login, arahkan ke HOME
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.snackbar(
          'Verification Needed',
          'Please verify your email to log in. A verification email has been sent.',
          backgroundColor: Colors.orange,
        );

        await userCredential.user?.sendEmailVerification();
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        Get.snackbar('Error', 'The email format is invalid.');
      } else if (e.code == 'user-disabled') {
        Get.snackbar('Error', 'This user has been disabled.');
      } else {
        Get.snackbar('Error', e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  void logout() async {
    await _auth.signOut();

    // Hapus token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Bersihkan status bookmark
    ngalamTerbaruController.bookmarkStatus.clear();

    // Arahkan ke halaman login
    Get.offAllNamed(Routes.HOME);
  }
}
