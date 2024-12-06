import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/readdetailartikel/controllers/readdetailartikel_controller.dart';

class ReadDetailArtikelView extends StatelessWidget {
  final String articleId; // ID artikel yang diterima dari halaman sebelumnya
  final ReaddetailartikelController _controller =
      Get.put(ReaddetailartikelController());

  ReadDetailArtikelView({required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Detail Artikel', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  _controller.bookmarkStatus[articleId] == true
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: _controller.bookmarkStatus[articleId] == true
                      ? Colors.blue
                      : Colors.grey,
                  size: 24,
                )),
            onPressed: () {
              _controller.toggleBookmark(articleId);
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection(
                'Home') // Atau collection 'Informasi' jika datanya di sana
            .doc(articleId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Article not found"));
          }

          // Konversi articleData menjadi Map<String, dynamic>
          var articleData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    articleData['judul_artikel'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(articleData['nama_upload'] ?? 'Unknown'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            articleData['tanggal_upload'] != null
                                ? DateFormat('dd-MM-yyyy').format(
                                    (articleData['tanggal_upload'] as Timestamp)
                                        .toDate())
                                : 'No Date',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.black, thickness: 1),
                  SizedBox(height: 20),
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
                          child: Center(child: Text('No Image Available')),
                        ),
                  SizedBox(height: 20),
                  Text(
                    articleData['isi_artikel'] ?? 'No content available.',
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
