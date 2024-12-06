import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';

class NgalamReadTerbaruView extends StatelessWidget {
  // Menyimpan status bookmark menggunakan RxBool
  RxBool isBookmarked = false.obs;

  @override
  Widget build(BuildContext context) {
    // Ambil data artikel yang dikirim sebagai argument
    final Map<String, dynamic> articleData = Get.arguments;

    // Ambil id_artikel dari data yang dikirimkan
    String idArtikel = articleData['id_artikel'] ?? ''; // Gunakan id_artikel

    // Mengonversi timestamp ke tanggal yang dapat dibaca
    String formattedDate = articleData['tanggal_upload'] != null
        ? DateFormat('yyyy-MM-dd')
            .format(articleData['tanggal_upload'].toDate())
        : 'No Date';

    // Set status bookmark saat pertama kali memuat data artikel
    if (articleData['isBookmarked'] != null) {
      isBookmarked.value = articleData['isBookmarked'] == true;
    }

    // Fungsi untuk mengupdate status bookmark di Firestore
    Future<void> updateBookmarkStatus() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Informasi')
            .where('id_artikel', isEqualTo: idArtikel)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

          bool newStatus = !isBookmarked.value;

          // Update nilai isBookmarked di Firestore
          await documentSnapshot.reference.update({'isBookmarked': newStatus});

          // Perbarui status bookmark secara lokal
          isBookmarked.value = newStatus;

          // Update juga di controller agar sinkron dengan halaman daftar
          Get.find<NgalamTerbaruController>().bookmarkStatus[idArtikel] =
              newStatus;

          print('Bookmark updated for ID: $idArtikel -> $newStatus');
        }
      } catch (e) {
        print('Error updating bookmark: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(articleData['kategori'] ?? 'No Category'),
            SizedBox(width: 10),
            // Membungkus IconButton dengan Obx untuk status reaktif
            Obx(() {
              return IconButton(
                icon: Icon(
                  isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked.value ? Colors.blue : Colors.grey,
                ),
                onPressed: () async {
                  // Perbarui status bookmark di Firestore dan UI
                  await updateBookmarkStatus();
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
              // Tampilkan judul artikel dengan align justify
              Text(
                articleData['judul_artikel'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

              // Tampilkan nama pengunggah dan tanggal upload bersampingan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(articleData['nama_upload'] ?? 'Unknown'),
                    ],
                  ),
                  Text(
                    'Uploaded on: $formattedDate',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Garis lurus hitam di bawah nama dan tanggal
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(height: 20),

              // Tampilkan gambar jika ada
              articleData['gambar_url'] != null
                  ? SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        articleData['gambar_url'],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(child: Text('No Image Available'))),
              SizedBox(height: 20),

              // Tampilkan konten atau deskripsi artikel dengan justify
              Text(
                articleData['isi_artikel'] ?? 'No content available.',
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
