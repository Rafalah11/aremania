import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_saya_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketSayaView extends GetView<TicketSayaController> {
  const TicketSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek apakah pengguna sudah login dengan Firebase Authentication
    final user = FirebaseAuth.instance.currentUser;

    // Jika pengguna belum login, arahkan ke halaman login
    if (user == null) {
      // Menggunakan Get.toNamed untuk menavigasi ke halaman login
      Future.delayed(Duration.zero, () {
        Get.toNamed('/login'); // Ganti '/login' dengan route halaman login Anda
      });
      return Center(
          child: CircularProgressIndicator()); // Menampilkan loading sementara
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Saya'),
        centerTitle: true,
        backgroundColor: Color(0xFF1A237E), // Warna appbar
        titleTextStyle: TextStyle(
          color: Colors.white, // Mengubah warna teks menjadi putih
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
            color: Colors.white), // Mengubah warna ikon menjadi putih
      ),
      body: Obx(() {
        print('isTicketPurchased: ${controller.isTicketPurchased.value}');
        if (!controller.isTicketPurchased.value) {
          return Center(
            child: Text(
              'Anda belum membeli tiket.',
              style: TextStyle(fontSize: 18),
            ),
          );
        } else {
          // Menampilkan detail tiket
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu Tiket
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Tiket
                      Row(
                        children: [
                          Icon(Icons.confirmation_number,
                              color: Color(0xFF1A237E), size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Kode Tiket: ${controller.idDokumen.value}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Informasi Tiket
                      Text(
                        "Email Pembeli: ${controller.email.value}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Jenis Tiket: ${controller.jenisTicket.value}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Jumlah Tiket: ${controller.ticketCount.value}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Total Harga: Rp ${controller.totalPrice.value}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // Grafik Tiket
                      Divider(),
                      Center(
                        child: Text(
                          "Tiket Berhasil Dibeli!",
                          style: TextStyle(fontSize: 18, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
