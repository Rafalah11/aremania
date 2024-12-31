import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/readdetailartikel/controllers/readdetailartikel_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ReadDetailArtikelView extends StatelessWidget {
  final ReaddetailartikelController _controller =
      Get.put(ReaddetailartikelController());

  @override
  Widget build(BuildContext context) {
    // Ambil argumen dari Get.arguments
    final Map<String, dynamic> articleData = Get.arguments;

    if (articleData.isEmpty) {
      return Scaffold(
        body: Center(child: Text('Invalid Article ID or Data')),
      );
    }

    final String idArtikel = articleData['id']; // ID artikel yang dikirimkan
    final Map<String, dynamic> isiArtikel =
        articleData['data']; // Data artikel yang dikirimkan

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Sesuaikan tinggi AppBar
        child: Obx(() {
          // Ambil status bookmark dari bookmarkStatus dengan ID artikel
          bool isBookmarked = _controller.bookmarkStatus[idArtikel] ?? false;

          return AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
            title:
                Text('Detail Artikel', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.blue : Colors.grey,
                  size: 24,
                ),
                onPressed: () {
                  var currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    // Jika belum login, arahkan ke halaman login
                    Get.toNamed(Routes.HALAMAN_LOGIN);
                    return;
                  }
                  // Toggle bookmark
                  _controller.toggleBookmark(idArtikel);
                },
              ),
            ],
          );
        }),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection(
                'Home') // Atau collection 'Informasi' jika datanya di sana
            .doc(idArtikel) // Penggunaan idArtikel yang sudah dipastikan valid
            .get(),
        builder: (context, snapshot) {
          // Cek status koneksi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Cek jika data tidak tersedia
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Article not found"));
          }
          String formattedDate = DateFormat('dd MMMM yyyy')
              .format(isiArtikel['tanggal_upload'].toDate());

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul artikel
                  Text(
                    isiArtikel['judul_artikel'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  // Informasi penulis dan tanggal upload
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(isiArtikel['nama_upload'] ?? 'Unknown'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.black, thickness: 1),
                  SizedBox(height: 20),
                  // Gambar artikel
                  isiArtikel['gambar_url'] != null
                      ? SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            isiArtikel['gambar_url'],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(child: Text('No Image Available')),
                        ),
                  SizedBox(height: 20),
                  // Isi artikel
                  Text(
                    isiArtikel['isi_artikel'] ?? 'No content available.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
