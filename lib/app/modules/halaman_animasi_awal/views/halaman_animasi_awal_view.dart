import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/app/modules/home/views/home_view.dart';

void main() {
  runApp(HalamanAnimasiAwalView());
}

class HalamanAnimasiAwalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk memindahkan ke halaman berikutnya setelah 3 detik
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda'),
      ),
      body: Center(
        child: Text('Ini adalah halaman utama setelah splash screen'),
      ),
    );
  }
}
