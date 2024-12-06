import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart'; // Ganti dengan import yang sesuai

class AdminTiketView extends StatefulWidget {
  @override
  AdminTiketViewState createState() => AdminTiketViewState();
}

class AdminTiketViewState extends State<AdminTiketView> {
  final _formKey = GlobalKey<FormState>();

  // Variabel untuk menyimpan data input
  String? dana,
      deskripsi,
      gopay,
      hargaTribunTimurUtaraSelatan,
      hargaVipBaratSelatan;
  String? hargaVipUtama,
      ovo,
      pertandingan,
      shopeepay,
      tempat,
      timAway,
      timHome,
      transferBank;
  DateTime? waktu;
  XFile? gambar; // Gambar yang akan diupload ke Firebase Storage

  final picker = ImagePicker();
  final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // Controllers untuk form fields
  final TextEditingController danaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController gopayController = TextEditingController();
  final TextEditingController hargaTribunTimurUtaraSelatanController =
      TextEditingController();
  final TextEditingController hargaVipBaratSelatanController =
      TextEditingController();
  final TextEditingController hargaVipUtamaController = TextEditingController();
  final TextEditingController ovoController = TextEditingController();
  final TextEditingController pertandinganController = TextEditingController();
  final TextEditingController shopeepayController = TextEditingController();
  final TextEditingController tempatController = TextEditingController();
  final TextEditingController timAwayController = TextEditingController();
  final TextEditingController timHomeController = TextEditingController();
  final TextEditingController transferBankController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();

  // Fungsi untuk memilih gambar
  void _pickImage() async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      gambar = selectedImage;
    });
  }

  // Fungsi untuk upload gambar ke Firebase Storage dan mendapatkan URL-nya
  Future<String?> _uploadImage(XFile? imageFile) async {
    if (imageFile == null) return null;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('ticket_images/${imageFile.name}');
      await storageRef.putFile(File(imageFile.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Fungsi untuk memilih waktu (timestamp)
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (selectedTime != null) {
        setState(() {
          waktu = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          waktuController.text = dateFormat.format(waktu!);
        });
      }
    }
  }

  // Fungsi submit untuk memasukkan data ke Firestore
  // Fungsi submit untuk memasukkan data ke Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Cek apakah ada input yang masih kosong
      if (danaController.text.isEmpty ||
          deskripsiController.text.isEmpty ||
          gopayController.text.isEmpty ||
          hargaTribunTimurUtaraSelatanController.text.isEmpty ||
          hargaVipBaratSelatanController.text.isEmpty ||
          hargaVipUtamaController.text.isEmpty ||
          ovoController.text.isEmpty ||
          pertandinganController.text.isEmpty ||
          shopeepayController.text.isEmpty ||
          tempatController.text.isEmpty ||
          timAwayController.text.isEmpty ||
          timHomeController.text.isEmpty ||
          transferBankController.text.isEmpty ||
          waktu == null) {
        // Tampilkan snackbar jika ada input yang kosong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Textfield tidak Boleh Ada Yang Kosong')),
        );
        return;
      }

      _formKey.currentState!.save();

      // Ambil user_id dari Firebase Authentication
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID tidak ditemukan')),
        );
        return;
      }

      // Upload gambar ke Firebase Storage
      String? imageUrl = await _uploadImage(gambar);

      // Masukkan data dan URL gambar ke dalam Firestore pada collection 'ticket'
      await FirebaseFirestore.instance.collection('ticket').add({
        'dana': dana,
        'deskripsi': deskripsi,
        'gopay': gopay,
        'harga_tribun_timur_utara_selatan': hargaTribunTimurUtaraSelatan,
        'harga_vip_barat_selatan': hargaVipBaratSelatan,
        'harga_vip_utama': hargaVipUtama,
        'ovo': ovo,
        'pertandingan': pertandingan,
        'shopeepay': shopeepay,
        'tempat': tempat,
        'tim_away': timAway,
        'tim_home': timHome,
        'transfer_bank': transferBank,
        'waktu': waktu,
        'gambar_url': imageUrl,
        'user_id': userId, // Menambahkan user_id
      });

      // Setelah data ditambahkan ke koleksi 'ticket', salin data ke koleksi 'transaksi_ticket_valid'
      await FirebaseFirestore.instance
          .collection('transaksi_ticket_valid')
          .add({
        'dana': dana,
        'deskripsi': deskripsi,
        'gopay': gopay,
        'harga_tribun_timur_utara_selatan': hargaTribunTimurUtaraSelatan,
        'harga_vip_barat_selatan': hargaVipBaratSelatan,
        'harga_vip_utama': hargaVipUtama,
        'ovo': ovo,
        'pertandingan': pertandingan,
        'shopeepay': shopeepay,
        'tempat': tempat,
        'tim_away': timAway,
        'tim_home': timHome,
        'transfer_bank': transferBank,
        'waktu': waktu,
        'gambar_url': imageUrl,
        'user_id': userId, // Menambahkan user_id
      });

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil ditambahkan!')),
      );

      // Reset form dan variabel setelah submit
      _formKey.currentState!.reset();
      danaController.clear();
      deskripsiController.clear();
      gopayController.clear();
      hargaTribunTimurUtaraSelatanController.clear();
      hargaVipBaratSelatanController.clear();
      hargaVipUtamaController.clear();
      ovoController.clear();
      pertandinganController.clear();
      shopeepayController.clear();
      tempatController.clear();
      timAwayController.clear();
      timHomeController.clear();
      transferBankController.clear();
      waktuController.clear();
      setState(() {
        gambar = null;
        waktu = null;
      });
    }
  }

  // Fungsi untuk logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Melakukan logout dari Firebase
    Get.offAllNamed(Routes.HOME); // Mengarahkan ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Tiket'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Memanggil fungsi logout saat ditekan
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: danaController,
              decoration: InputDecoration(labelText: 'Dana'),
              onSaved: (value) => dana = value,
            ),
            TextFormField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
              onSaved: (value) => deskripsi = value,
              maxLines: 5,
            ),
            TextFormField(
              controller: gopayController,
              decoration: InputDecoration(labelText: 'Gopay'),
              onSaved: (value) => gopay = value,
            ),
            TextFormField(
              controller: hargaTribunTimurUtaraSelatanController,
              decoration: InputDecoration(
                  labelText: 'Harga Tribun Timur Utara Selatan'),
              onSaved: (value) => hargaTribunTimurUtaraSelatan = value,
            ),
            TextFormField(
              controller: hargaVipBaratSelatanController,
              decoration: InputDecoration(labelText: 'Harga VIP Barat Selatan'),
              onSaved: (value) => hargaVipBaratSelatan = value,
            ),
            TextFormField(
              controller: hargaVipUtamaController,
              decoration: InputDecoration(labelText: 'Harga VIP Utama'),
              onSaved: (value) => hargaVipUtama = value,
            ),
            TextFormField(
              controller: ovoController,
              decoration: InputDecoration(labelText: 'Ovo'),
              onSaved: (value) => ovo = value,
            ),
            TextFormField(
              controller: pertandinganController,
              decoration: InputDecoration(labelText: 'Pertandingan'),
              onSaved: (value) => pertandingan = value,
            ),
            TextFormField(
              controller: shopeepayController,
              decoration: InputDecoration(labelText: 'ShopeePay'),
              onSaved: (value) => shopeepay = value,
            ),
            TextFormField(
              controller: tempatController,
              decoration: InputDecoration(labelText: 'Tempat'),
              onSaved: (value) => tempat = value,
            ),
            TextFormField(
              controller: timAwayController,
              decoration: InputDecoration(labelText: 'Tim Away'),
              onSaved: (value) => timAway = value,
            ),
            TextFormField(
              controller: timHomeController,
              decoration: InputDecoration(labelText: 'Tim Home'),
              onSaved: (value) => timHome = value,
            ),
            TextFormField(
              controller: transferBankController,
              decoration: InputDecoration(labelText: 'Transfer Bank'),
              onSaved: (value) => transferBank = value,
            ),
            TextFormField(
              controller: waktuController,
              decoration: InputDecoration(labelText: 'Waktu'),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(gambar == null ? 'Pilih Gambar' : 'Gambar Terpilih'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Tambah Tiket'),
            ),
            SizedBox(height: 20), // Jarak tambahan ke bawah
          ],
        ),
      ),
    );
  }
}
