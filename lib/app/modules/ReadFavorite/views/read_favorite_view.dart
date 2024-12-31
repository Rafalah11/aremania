import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReadFavoriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data artikel yang dikirim sebagai argument
    final Map<String, dynamic> articleData = Get.arguments;
    final Map<String, dynamic> isiArtikel =
        articleData['data']; // Data artikel yang dikirimkan

    // // Mengonversi timestamp ke tanggal yang dapat dibaca
    String formattedDate = DateFormat('dd MMMM yyyy')
        .format(isiArtikel['tanggal_upload'].toDate());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isiArtikel['kategori'] ?? 'No Title',
        ),
        centerTitle: true, // Menengahkan teks di AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Tampilkan judul artikel dengan align justify
              Text(
                isiArtikel['judul_artikel'] ?? 'No Title',
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
                      Text(isiArtikel['nama_upload'] ?? 'Unknown'),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 10),

// Garis lurus hitam di bawah nama dan tanggal
              Divider(
                color: Colors.black, // Warna garis
                thickness: 1, // Ketebalan garis
              ),
              SizedBox(height: 20),
// Tampilkan gambar jika ada
              isiArtikel['gambar_url'] != null
                  ? SizedBox(
                      width: double
                          .infinity, // Memastikan gambar memenuhi lebar layar
                      child: Image.network(
                        isiArtikel['gambar_url'],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double
                          .infinity, // Memastikan kontainer juga memenuhi lebar layar
                      color: Colors.grey[300],
                      child: Center(child: Text('No Image Available')),
                    ),
              SizedBox(height: 20),

// Contoh: Tampilkan konten atau deskripsi artikel dengan justify
              Text(
                isiArtikel['isi_artikel'] ?? 'No content available.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Menjadikan teks rata kiri-kanan
              ),
            ],
          ),
        ),
      ),
    );
  }
}
