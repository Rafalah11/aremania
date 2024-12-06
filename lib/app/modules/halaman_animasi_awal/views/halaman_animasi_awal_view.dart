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
    Timer(Duration(seconds: 5), _navigateBasedOnAuth);
  }

  // Fungsi untuk menavigasi berdasarkan status autentikasi pengguna
  void _navigateBasedOnAuth() async {

    // Tunggu status autentikasi
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Jika pengguna sudah login, arahkan ke home atau admin
      if (user.email == 'admin@example.com') {
        // Arahkan ke halaman admin
        Get.offAllNamed(Routes.MANAGEMENT_ADMIN);
      } else {
        // Arahkan ke halaman home
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      // Jika pengguna belum login, arahkan ke halaman login
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
