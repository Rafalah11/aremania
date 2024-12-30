import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminTiketController extends GetxController {
  // Controllers untuk form fields
  final TextEditingController timAwayController = TextEditingController();
  final TextEditingController timHomeController = TextEditingController();
  final TextEditingController tempatController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController jenisTiketController = TextEditingController();
  final TextEditingController danaController = TextEditingController();
  final TextEditingController ovoController = TextEditingController();
  final TextEditingController shopeepayController = TextEditingController();
  final TextEditingController gopayController = TextEditingController();
  final TextEditingController transferBankController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  // Variabel untuk menyimpan data input
  String? timAway, timHome, tempat, deskripsi;
  int? jenisTiketCount; // Jumlah jenis tiket
  List<String> jenisTiketNames = [];
  List<double> jenisTiketPrices = [];
  List<int> jenisTiketSeats = []; // Jumlah kursi per jenis tiket
  String? dana, ovo, shopeepay, gopay, transferBank;
  DateTime? waktu;

  // Add gambar as an XFile (for image selection)
  XFile? gambar; // This holds the selected image file

  // Fungsi untuk membuat kursi berdasarkan jumlah
  List<Kursi> createSeats(int count) {
    return List.generate(count, (index) => Kursi(id: 'kursi_${index + 1}'));
  }
}

class Kursi {
  String id; // ID unik untuk setiap kursi
  String status; // Status kursi (Available, Verifying, Booked)

  Kursi({required this.id, this.status = 'Available'});
}
