import 'package:flutter/material.dart';
import 'package:myapp/app/modules/arema_editorial/views/arema_editorial_view.dart';
import 'package:myapp/app/modules/aremaday_semua/views/aremaday_semua_view.dart';
import 'package:myapp/app/modules/aremania_semua/views/aremania_semua_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';

void main() {
  runApp(KategoriView());
}

class KategoriView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: kategori(),
    );
  }
}

class kategori extends StatelessWidget {
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
            // Aksi kembali
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Aksi pencarian
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language,
                color: Colors.blue), // Ganti dengan ikon yang sesuai
            title: Text('Ngalam'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NgalamTerbaruView()), // Ganti dengan nama halaman yang sesuai
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star,
                color: Colors.blue), // Ganti dengan ikon yang sesuai
            title: Text('Berita Arema'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AremaEditorialView()), // Ganti dengan nama halaman yang sesuai
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.blue),
            title: Text('Aremania'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AremaniaSemuaView()), // Ganti dengan nama halaman yang sesuai
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.public,
                color: Colors.blue), // Ganti dengan ikon yang sesuai
            title: Text('Nasional'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AremadaySemuaView()), // Ganti dengan nama halaman yang sesuai
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Colors.blue), // Ganti dengan ikon yang sesuai
            title: Text('Jadwal Pertandingan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Aksi ketika di-tap
            },
          ),
        ],
      ),
    );
  }
}
