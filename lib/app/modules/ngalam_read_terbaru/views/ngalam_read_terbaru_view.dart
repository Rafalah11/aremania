import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';

class NgalamReadTerbaruView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data yang dikirimkan dari Get.arguments
    final Map<String, dynamic> articleData = Get.arguments;
    final String idArtikel = articleData['id']; // ID artikel yang dikirimkan
    final Map<String, dynamic> isiArtikel =
        articleData['data']; // Data artikel yang dikirimkan

    // Format tanggal jika ada
    String formattedDate = isiArtikel['tanggal_upload'] != null
        ? DateFormat('yyyy-MM-dd').format(isiArtikel['tanggal_upload'].toDate())
        : 'No Date';

    final NgalamTerbaruController controller =
        Get.find<NgalamTerbaruController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan kategori artikel
            Text(isiArtikel['kategori'] ?? 'No Category'),
            SizedBox(width: 10),
            // Membungkus IconButton dengan Obx untuk status reaktif
            Obx(() {
              bool isBookmarked = controller.bookmarkStatus[idArtikel] ?? false;
              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  controller.toggleBookmark(idArtikel);
                },
              );
            }),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan judul artikel
              Text(
                isiArtikel['judul_artikel'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              // Menampilkan nama pengunggah dan tanggal upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(isiArtikel['nama_upload'] ?? 'Unknown'),
                    ],
                  ),
                  Text(
                    'Uploaded on: $formattedDate',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(height: 20),
              // Menampilkan gambar artikel jika ada
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
                      child: Center(child: Text('No Image Available'))),
              SizedBox(height: 20),
              // Menampilkan konten atau isi artikel
              Text(
                isiArtikel['isi_artikel'] ?? 'No content available.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
