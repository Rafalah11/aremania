import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HalamanProfileView extends StatelessWidget {
  final HalamanInformasiPribadiController halamanInformasiPribadiController =
      Get.find<HalamanInformasiPribadiController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: halamanInformasiPribadiController
                          .photoUrl.value.isNotEmpty
                      ? NetworkImage(
                          halamanInformasiPribadiController.photoUrl.value)
                      : null, // Tampilkan gambar dari Firebase jika ada
                  child:
                      halamanInformasiPribadiController.photoUrl.value.isEmpty
                          ? Icon(Icons.person, size: 60, color: Colors.white)
                          : null, // Tampilkan ikon jika foto tidak tersedia
                ),
              ),
              SizedBox(height: 8),
              Obx(
                () => Text(
                  halamanInformasiPribadiController.nama.value.isNotEmpty
                      ? halamanInformasiPribadiController.nama.value
                      : 'Nama Pengguna', // Tampilkan nama dari Firebase atau teks default
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(
                () => Text(
                  halamanInformasiPribadiController.email.value.isNotEmpty
                      ? halamanInformasiPribadiController.email.value
                      : 'Email tidak tersedia', // Tampilkan email dari Firebase atau teks default
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ProfileOption(
                icon: Icons.person,
                title: 'Informasi Pribadi',
                onTap: () {
                  Get.toNamed(Routes.HALAMAN_INFORMASI_PRIBADI);
                },
              ),
              ProfileOption(
                icon: Icons.privacy_tip,
                title: 'Kebijakan Privasi',
                onTap: () {
                  Get.toNamed(Routes.KEBIJAKAN_PRIVASI);
                },
              ),
              ProfileOption(
                icon: Icons.security,
                title: 'Kata Sandi dan Keamanan',
                onTap: () {
                  Get.toNamed(Routes.KATA_SANDI);
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
                  Get.toNamed(Routes.PUSAT_BANTUAN);
                },
              ),
              ProfileOption(
                icon: Icons.report,
                title: 'Laporkan Masalah',
                onTap: () {
                  Get.toNamed(Routes.LAPORKAN_MASALAH);
                },
              ),
              ProfileOption(
                icon: Icons.question_answer,
                title: 'FAQ',
                onTap: () {
                  Get.toNamed(Routes.FAQ);
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
  final VoidCallback onTap;

  ProfileOption({
    required this.icon,
    required this.title,
    this.color = Colors.black,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
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
