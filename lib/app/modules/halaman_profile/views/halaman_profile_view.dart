import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/app/controllers/auth_controller.dart';

class HalamanProfileView extends StatelessWidget {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // Aksi untuk ikon profil
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Menambahkan scrollable view
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Emmie Watson',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'emmie170@gmail.com',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              ProfileOption(
                icon: Icons.person,
                title: 'Informasi Pribadi',
                onTap: () {
                  // TODO: Navigasi ke halaman Informasi Pribadi
                },
              ),
              ProfileOption(
                icon: Icons.privacy_tip,
                title: 'Kebijakan Privasi',
                onTap: () {
                  // TODO: Navigasi ke halaman Kebijakan Privasi
                },
              ),
              ProfileOption(
                icon: Icons.security,
                title: 'Kata Sandi dan Keamanan',
                onTap: () {
                  // TODO: Navigasi ke halaman Kata Sandi dan Keamanan
                },
              ),
              ProfileOption(
                icon: Icons.settings,
                title: 'Pengaturan',
                onTap: () {
                  // TODO: Navigasi ke halaman Pengaturan
                },
              ),
              SizedBox(height: 20),
              SectionTitle(title: 'More'),
              ProfileOption(
                icon: Icons.help,
                title: 'Pusat Bantuan',
                onTap: () {
                  // TODO: Navigasi ke halaman Pusat Bantuan
                },
              ),
              ProfileOption(
                icon: Icons.report,
                title: 'Laporkan Masalah',
                onTap: () {
                  // TODO: Navigasi ke halaman Laporkan Masalah
                },
              ),
              ProfileOption(
                icon: Icons.question_answer,
                title: 'FAQ',
                onTap: () {
                  // TODO: Navigasi ke halaman FAQ
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                title: 'Keluar',
                color: Colors.red,
                onTap: () {
                  authController.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap; // Menambahkan callback untuk onTap

  ProfileOption({
    required this.icon,
    required this.title,
    this.color = Colors.black,
    required this.onTap, // Menandai onTap sebagai parameter wajib
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap, // Menggunakan onTap untuk aksi
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
