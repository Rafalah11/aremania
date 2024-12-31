import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart'; // Ganti dengan import yang sesuai

class AdminFormPage extends StatefulWidget {
  @override
  AdmininformasiView createState() => AdmininformasiView();
}

class AdmininformasiView extends State<AdminFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? idArtikel, judulArtikel, namaUpload, isiArtikel;
  DateTime? tanggalUpload;
  XFile? gambar;
  List<String> subKategoriList = [];

  String? kategori; // Variabel untuk menyimpan nilai kategori yang dipilih
  final List<String> kategoriList = [
    'ngalam',
    'arema',
    'aremania',
    'nasional',
  ]; // Daftar pilihan kategori

  String? subKategori;

  final Map<String, List<String>> kategoriSubKategoriMap = {
    'ngalam': ['terbaru', 'destinasi', 'malangan', 'kuliner', 'info_penting'],
    'arema': ['editorial', 'arema_putri', 'berita_foto', 'arema_junior'],
    'aremania': [],
    'nasional': [],
  };

  final picker = ImagePicker();
  final dateFormat = DateFormat('yyyy-MM-dd');

  // Controllers untuk form fields
  final TextEditingController idArtikelController = TextEditingController();
  final TextEditingController judulArtikelController = TextEditingController();
  final TextEditingController namaUploadController = TextEditingController();
  final TextEditingController isiArtikelController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController subKategoriController = TextEditingController();
  final TextEditingController tanggalUploadController = TextEditingController();

  // Fungsi untuk memilih gambar
  void _pickImage(bool isPrimary) async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isPrimary) {
        gambar = selectedImage;
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
          kategori == null ||
          subKategori == null ||
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

      // Masukkan data dan URL gambar ke dalam Firestore
      await FirebaseFirestore.instance.collection('Informasi').add({
        'id_artikel': idArtikel,
        'judul_artikel': judulArtikel,
        'tanggal_upload': tanggalUpload,
        'nama_upload': namaUpload,
        'isi_artikel': isiArtikel,
        'kategori': kategori,
        'sub_kategori': subKategori,
        'gambar_url': imageUrl,
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
      subKategoriController.clear();
      tanggalUploadController.clear();
      setState(() {
        tanggalUpload = null;
        gambar = null;
        kategori = null;
        subKategori == null;
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
        title: Text('Admin Informasi'),
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
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: kategori, // Nilai awal dropdown kategori
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: kategoriList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  kategori = value; // Simpan nilai kategori
                  subKategori =
                      null; // Reset sub-kategori saat kategori berubah
                  subKategoriList = kategoriSubKategoriMap[kategori] ??
                      []; // Update sub-kategori
                });
              },
              onSaved: (value) => kategori = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kategori harus dipilih';
                }
                return null;
              },
            ),

            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: subKategori, // Nilai awal dropdown sub-kategori
              decoration: InputDecoration(
                labelText: 'Sub-Kategori',
                border: OutlineInputBorder(),
              ),
              items: subKategoriList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  subKategori = value; // Simpan nilai sub-kategori
                });
              },
              onSaved: (value) => subKategori = value,
              validator: (value) {
                if (kategori == 'aremania' || kategori == 'nasional') {
                  return null; // Tidak perlu validasi untuk kategori tanpa sub-kategori
                }
                if (value == null || value.isEmpty) {
                  return 'Sub-Kategori harus dipilih';
                }
                return null;
              },
            ),

            SizedBox(height: 15),
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
