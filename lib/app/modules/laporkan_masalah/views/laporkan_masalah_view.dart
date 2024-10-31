import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/laporkan_masalah/controllers/laporkan_masalah_controller.dart';

class LaporkanMasalahView extends StatelessWidget {
  final LaporkanMasalahController controller =
      Get.put(LaporkanMasalahController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Issue Screen',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false, // Menyembunyikan debug banner
      home: ReportIssueScreen(controller: controller),
    );
  }
}

class ReportIssueScreen extends StatelessWidget {
  final LaporkanMasalahController controller;
  final TextEditingController textController = TextEditingController();

  ReportIssueScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Laporkan masalah'),
        actions: [
          TextButton(
            onPressed: () {
              // Set description from textController
              controller.description.value = textController.text;

              // Panggil sendReport() tanpa menangkap hasil
              controller.sendReport();

              // Kosongkan TextField setelah laporan dikirim
              textController.clear();

              // Menampilkan snackbar sebagai feedback
              Get.snackbar(
                'Sukses',
                'Laporan berhasil dikirim',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text(
              'Kirim',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jelaskan secara singkat apa yang terjadi atau apa yang tidak berfungsi.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: textController, // Use TextEditingController
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan deskripsi masalah...',
                ),
              ),
              SizedBox(height: 16.0), // Menambahkan jarak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.image),
                        iconSize: 48,
                        onPressed: () {},
                      ),
                      Text('Unggah', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        iconSize: 48,
                        onPressed: () {},
                      ),
                      Text('Cuplikan Layar', style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0), // Menambahkan jarak di bawah row
            ],
          ),
        ),
      ),
    );
  }
}
