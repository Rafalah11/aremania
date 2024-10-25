import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/arema_editorial/views/arema_editorial_view.dart';
import 'package:myapp/app/modules/aremaday_semua/views/aremaday_semua_view.dart';
import 'package:myapp/app/modules/aremania_semua/views/aremania_semua_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Menggunakan GetMaterialApp sebagai root
      debugShowCheckedModeBanner: false,
      home: KategoriView(),
    );
  }
}

class KategoriView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); // Menggunakan Get.back untuk kembali ke halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Tambahkan fungsi pencarian di sini jika diperlukan
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language,
                color: Colors.blue), // Ikon untuk halaman Ngalam
            title: Text('Ngalam'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() =>
                  NgalamTerbaruView()); // Navigasi ke halaman Ngalam Terbaru
            },
          ),
          ListTile(
            leading: Icon(Icons.star,
                color: Colors.blue), // Ikon untuk halaman Berita Arema
            title: Text('Berita Arema'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() =>
                  AremaEditorialView()); // Navigasi ke halaman Arema Editorial
            },
          ),
          ListTile(
            leading: Icon(Icons.people,
                color: Colors.blue), // Ikon untuk halaman Aremania
            title: Text('Aremania'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() =>
                  AremaniaSemuaView()); // Navigasi ke halaman Aremania Semua
            },
          ),
          ListTile(
            leading: Icon(Icons.public,
                color: Colors.blue), // Ikon untuk halaman Nasional
            title: Text('Nasional'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() =>
                  AremadaySemuaView()); // Navigasi ke halaman Arema Day Semua
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Colors.blue), // Ikon untuk Jadwal Pertandingan
            title: Text('Jadwal Pertandingan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Tambahkan fungsi untuk halaman Jadwal Pertandingan
            },
          ),
        ],
      ),
    );
  }
}
