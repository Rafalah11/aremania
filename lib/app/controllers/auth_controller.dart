import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      // Proses login ke Firebase dengan email dan password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cek apakah email adalah admin menggunakan Firestore atau logika lainnya
      if (email == 'admin@gmail.com' && password == '123456') {
        // Jika admin, langsung masuk ke halaman admin
        Get.offAllNamed(Routes.MANAGEMENT_ADMIN);
        return;
      }

      // Cek status verifikasi email untuk pengguna biasa
      if (userCredential.user?.emailVerified ?? false) {
        // Jika email sudah diverifikasi, simpan status login di SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'token', 'your_token_value'); // Gantilah dengan token yang sesuai

        Get.snackbar('Success', 'Login successful',
            backgroundColor: Colors.green);

        var currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          // Muat status bookmark setelah login
          ngalamTerbaruController.loadBookmarkStatus();
        }

        // Jika berhasil login, arahkan ke HOME
        Get.offAllNamed(Routes.HOME);
      } else {
        // Jika email belum diverifikasi, beri tahu pengguna
        Get.snackbar(
          'Verification Needed',
          'Please verify your email to log in. A verification email has been sent.',
          backgroundColor: Colors.orange,
        );

        // Kirim ulang email verifikasi
        await userCredential.user?.sendEmailVerification();

        // Logout agar sesi tidak disimpan
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

  // User? currentUser = userCredential.user;

  // if (currentUser != null) {
  //   if (currentUser.emailVerified) {
  //     // Simpan status login di SharedPreferences
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('uid', currentUser.uid);

  //     // Ambil FCM token
  //     final fcmToken = await FirebaseMessaging.instance.getToken();
  //     if (fcmToken != null) {
  //       // Simpan token ke Firestore
  //       await FirebaseFirestore.instance
  //           .collection('FCMUsers')
  //           .doc(currentUser.uid)
  //           .set({'fcmToken': fcmToken}, SetOptions(merge: true));
  //     }

  //     Get.snackbar('Success', 'Login successful',
  //         backgroundColor: Colors.green);

  //     // Muat status bookmark
  //     ngalamTerbaruController.loadBookmarkStatus();

  //     // Arahkan ke HOME
  //     Get.offAllNamed(Routes.HOME);

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
