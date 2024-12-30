import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import untuk Firebase Auth
import '../controllers/management_admin_controller.dart';

class ManagementAdminView extends GetView<ManagementAdminController> {
  const ManagementAdminView({super.key});

  // Fungsi untuk melakukan logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Melakukan logout dari Firebase
      Get.offAllNamed(
          Routes.HOME); // Mengarahkan ke halaman login setelah logout
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management Admin View'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Memanggil fungsi logout saat ditekan
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian 1: Artikel Home
          buildListTile(
            title: "Tambah Artikel Home",
            onTap: () {
              // Navigasi ke halaman Management Admin Home
              Get.toNamed(Routes.ADMIN_HOME);
            },
          ),
          // Bagian 2: Artikel Informasi
          buildListTile(
            title: "Tambah Artikel Informasi",
            onTap: () {
              // Navigasi ke halaman Management Admin Informasi
              Get.toNamed(Routes.ADMIN_INFORMASI);
            },
          ),
          // Bagian 3: Tiket
          buildListTile(
            title: "Tambah Data Tiket",
            onTap: () {
              // Navigasi ke halaman Management Admin Tiket
              Get.toNamed(Routes.ADMIN_TIKET);
            },
          ),
          // Bagian 4: Pembelian Tiket
          buildListTile(
            title: "Data Pembelian Tiket",
            onTap: () {
              // Navigasi ke halaman Management Admin Pembelian Tiket
              Get.toNamed(Routes.ADMIN_TRANSAKSI_TIKET);
            },
          ),
          buildListTile(
            title: "Data Kursi Pada Setiap Tiket",
            onTap: () {
              // Navigasi ke halaman Management Admin Pembelian Tiket
              Get.toNamed(Routes.ADMIN_KURSI_TIKET);
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk ListTile yang menampilkan pilihan dan aksi navigasi
  Widget buildListTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        leading: const Icon(Icons.arrow_forward),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      ),
    );
  }
}
