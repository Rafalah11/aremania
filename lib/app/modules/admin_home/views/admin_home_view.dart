import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart'; // Ganti dengan import yang sesuai

class AdminHomeView extends StatefulWidget {
  @override
  AdminHomeViewState createState() => AdminHomeViewState();
}

class AdminHomeViewState extends State<AdminHomeView> {
  final _formKey = GlobalKey<FormState>();
  String? idArtikel, judulArtikel, namaUpload, isiArtikel, kategori;
  DateTime? tanggalUpload;
  XFile? gambar, gambar2;

  final picker = ImagePicker();
  final dateFormat = DateFormat('yyyy-MM-dd');

  // Controllers untuk form fields
  final TextEditingController idArtikelController = TextEditingController();
  final TextEditingController judulArtikelController = TextEditingController();
  final TextEditingController namaUploadController = TextEditingController();
  final TextEditingController isiArtikelController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController tanggalUploadController = TextEditingController();

  // Fungsi untuk memilih gambar
  void _pickImage(bool isPrimary) async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isPrimary) {
        gambar = selectedImage;
      } else {
        gambar2 = selectedImage;
      }
    });
  }

  // Fungsi untuk upload gambar ke Firebase Storage dan mendapatkan URL-nya
  Future<String?> _uploadImage(XFile? imageFile) async {
    if (imageFile == null) return null;
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('images/${imageFile.name}');
      await storageRef.putFile(File(imageFile.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        tanggalUpload = selectedDate;
        tanggalUploadController.text = dateFormat.format(selectedDate);
      });
    }
  }

  // Fungsi submit untuk memasukkan data dan URL gambar ke Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Cek apakah ada input yang masih kosong
      if (idArtikelController.text.isEmpty ||
          judulArtikelController.text.isEmpty ||
          namaUploadController.text.isEmpty ||
          isiArtikelController.text.isEmpty ||
          kategoriController.text.isEmpty ||
          tanggalUpload == null) {
        // Tampilkan snackbar jika ada input yang kosong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Textfield tidak Boleh Ada Yang Kosong')),
        );
        return;
      }

      _formKey.currentState!.save();

      // Upload gambar utama dan gambar opsional ke Firebase Storage
      String? imageUrl = await _uploadImage(gambar);
      String? imageUrl2 = await _uploadImage(gambar2);

      // Masukkan data dan URL gambar ke dalam Firestore pada collection 'Home'
      await FirebaseFirestore.instance.collection('Home').add({
        'id_artikel': idArtikel,
        'judul_artikel': judulArtikel,
        'tanggal_upload': tanggalUpload,
        'nama_upload': namaUpload,
        'isi_artikel': isiArtikel,
        'kategori': kategori,
        'gambar_url': imageUrl,
        'gambar2_url': imageUrl2,
      });

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil ditambahkan!')),
      );

      // Reset form dan variabel setelah submit
      _formKey.currentState!.reset();
      idArtikelController.clear();
      judulArtikelController.clear();
      namaUploadController.clear();
      isiArtikelController.clear();
      kategoriController.clear();
      tanggalUploadController.clear();
      setState(() {
        tanggalUpload = null;
        gambar = null;
        gambar2 = null;
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
        title: Text('Admin Home'),
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
              controller: idArtikelController,
              decoration: InputDecoration(labelText: 'ID Artikel'),
              onSaved: (value) => idArtikel = value,
            ),
            TextFormField(
              controller: judulArtikelController,
              decoration: InputDecoration(labelText: 'Judul Artikel'),
              onSaved: (value) => judulArtikel = value,
            ),
            TextFormField(
              controller: namaUploadController,
              decoration: InputDecoration(labelText: 'Nama Upload'),
              onSaved: (value) => namaUpload = value,
            ),
            TextFormField(
              controller: isiArtikelController,
              decoration: InputDecoration(labelText: 'Isi Artikel'),
              onSaved: (value) => isiArtikel = value,
              maxLines: 5,
            ),
            TextFormField(
              controller: kategoriController,
              decoration: InputDecoration(labelText: 'Kategori'),
              onSaved: (value) => kategori = value,
            ),
            TextFormField(
              controller: tanggalUploadController,
              decoration: InputDecoration(labelText: 'Tanggal Upload'),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(true),
              child: Text(gambar == null
                  ? 'Pilih Gambar Utama'
                  : 'Gambar Utama Terpilih'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(false),
              child: Text(gambar2 == null
                  ? 'Pilih Gambar Kedua (Opsional)'
                  : 'Gambar Kedua Terpilih'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Tambah'),
            ),
            SizedBox(height: 20), // Jarak tambahan ke bawah
          ],
        ),
      ),
    );
  }
}
