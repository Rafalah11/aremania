import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HalamanAnimasiAwalView extends StatefulWidget {
  @override
  _HalamanAnimasiAwalViewState createState() => _HalamanAnimasiAwalViewState();
}

class _HalamanAnimasiAwalViewState extends State<HalamanAnimasiAwalView> {
  @override
  void initState() {
    super.initState();

    // Tunggu selama 5 detik untuk animasi
    Future.delayed(Duration(seconds: 5), _navigateBasedOnAuth);
  }

  // Fungsi untuk menavigasi berdasarkan status autentikasi pengguna
  void _navigateBasedOnAuth() async {
    // Cek status autentikasi
    User? user = FirebaseAuth.instance.currentUser;

    print("Navigating after 5 seconds...");

    if (user != null) {
      // Jika pengguna sudah login, arahkan ke halaman HOME
      print("User is logged in. Navigating to HOME.");
      Get.offAllNamed(Routes.HOME);
    } else {
      // Jika pengguna belum login, arahkan ke halaman login
      print("User is not logged in. Navigating to LOGIN.");
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logoweare.jpg', // Gambar logo
          width: 200, // Sesuaikan ukuran logo jika perlu
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
