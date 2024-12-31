import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/admin_tiket/controllers/admin_tiket_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class AdminTiketView extends StatefulWidget {
  @override
  AdminTiketViewState createState() => AdminTiketViewState();
}

class AdminTiketViewState extends State<AdminTiketView> {
  final _formKey = GlobalKey<FormState>();
  final AdminTiketController _controller = AdminTiketController();
  final picker = ImagePicker();
  final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  // Fungsi untuk memilih gambar
  void _pickImage() async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _controller.gambar = selectedImage;
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
          _controller.waktu = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _controller.waktuController.text =
              dateFormat.format(_controller.waktu!);
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Menyimpan semua data form ke dalam controller
      _formKey.currentState!.save();

      // Cek apakah ada input yang masih kosong
      if (_controller.danaController.text.isEmpty ||
          _controller.deskripsiController.text.isEmpty ||
          _controller.gopayController.text.isEmpty ||
          _controller.ovoController.text.isEmpty ||
          _controller.shopeepayController.text.isEmpty ||
          _controller.tempatController.text.isEmpty ||
          _controller.timAwayController.text.isEmpty ||
          _controller.timHomeController.text.isEmpty ||
          _controller.transferBankController.text.isEmpty ||
          _controller.waktu == null ||
          _controller.jenisTiketCount == null ||
          _controller.jenisTiketNames.isEmpty ||
          _controller.jenisTiketPrices.isEmpty ||
          _controller.jenisTiketSeats.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Textfield tidak Boleh Ada Yang Kosong')),
        );
        return;
      }

      // Ambil user_id dari Firebase Authentication
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID tidak ditemukan')),
        );
        return;
      }

      // Upload gambar ke Firebase Storage
      String? imageUrl = await _uploadImage(_controller.gambar);

      // Menyimpan data tiket dan kursi ke Firestore
      await FirebaseFirestore.instance.collection('ticket').add({
        'dana': _controller.danaController.text,
        'deskripsi': _controller.deskripsiController.text,
        'gopay': _controller.gopayController.text,
        'ovo': _controller.ovoController.text,
        'shopeepay': _controller.shopeepayController.text,
        'tempat': _controller.tempatController.text,
        'tim_away': _controller.timAwayController.text,
        'tim_home': _controller.timHomeController.text,
        'transfer_bank': _controller.transferBankController.text,
        'waktu': _controller.waktu,
        'gambar_url': imageUrl,
        'jenis_tiket':
            List.generate(_controller.jenisTiketNames.length, (index) {
          // Ambil nama jenis tiket
          String ticketName = _controller.jenisTiketNames[index];

          // Generate kursi berdasarkan jumlah kursi untuk jenis tiket tersebut
          List<Map<String, dynamic>> kursiList = [];
          for (int i = 0; i < _controller.jenisTiketSeats[index]; i++) {
            kursiList.add({
              'id': 'kursi_${i + 1}', // Id kursi mengikuti nomor kursi
              'status': 'Available', // Status kursi
              'harga': _controller.jenisTiketPrices[index], // Harga kursi
            });
          }

          // Return data jenis tiket dalam format yang diinginkan
          return {
            ticketName: kursiList, // Menggunakan nama jenis tiket sebagai key
          };
        }),
        'user_id': userId,
      });

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil ditambahkan!')),
      );

      // Reset form dan variabel setelah submit
      _formKey.currentState!.reset();
      _controller.danaController.clear();
      _controller.deskripsiController.clear();
      _controller.gopayController.clear();
      _controller.ovoController.clear();
      _controller.shopeepayController.clear();
      _controller.tempatController.clear();
      _controller.timAwayController.clear();
      _controller.timHomeController.clear();
      _controller.transferBankController.clear();
      _controller.waktuController.clear();
      setState(() {
        _controller.gambar = null;
        _controller.waktu = null;
        _controller.jenisTiketNames.clear(); // Pastikan list ini kosong
        _controller.jenisTiketPrices.clear(); // Pastikan list ini kosong
        _controller.jenisTiketSeats.clear(); // Pastikan list ini kosong
      });
    }
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
              controller: _controller.timAwayController,
              decoration: InputDecoration(labelText: 'Tim Away'),
            ),
            TextFormField(
              controller: _controller.timHomeController,
              decoration: InputDecoration(labelText: 'Tim Home'),
            ),
            TextFormField(
              controller: _controller.tempatController,
              decoration: InputDecoration(labelText: 'Tempat'),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue, // Warna 1
                    const Color.fromARGB(255, 0, 255, 94), // Warna 2
                    Colors.pink, // Warna 3
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                    10), // Membuat sudut tombol melengkung
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, // Warna tombol transparan agar gradasi terlihat
                  shadowColor:
                      Colors.transparent, // Menghapus bayangan bawaan tombol
                ),
                onPressed: () => _selectDate(context),
                child: Text(
                  _controller.waktu == null
                      ? 'Pilih Waktu'
                      : 'Waktu Terpilih: ${_controller.waktu}',
                  style: TextStyle(
                    color: const Color.fromARGB(
                        255, 0, 0, 0), // Warna teks agar kontras dengan gradasi
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: _controller.deskripsiController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            // Jenis Tiket Input
            TextFormField(
              controller: _controller.jenisTiketController,
              decoration: InputDecoration(labelText: 'Jenis Tiket'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _controller.jenisTiketCount = int.tryParse(value);
                });
              },
            ),
            // Dinamis form untuk nama, harga tiket, dan jumlah kursi
            if (_controller.jenisTiketCount != null)
              ...List.generate(
                _controller.jenisTiketCount!,
                (index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nama Jenis Tiket ${index + 1}',
                              ),
                              onSaved: (value) {
                                _controller.jenisTiketNames.add(value!);
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Harga Tiket ${index + 1}',
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                _controller.jenisTiketPrices
                                    .add(double.parse(value!));
                              },
                            ),
                          ),
                        ],
                      ),
                      // Input untuk jumlah kursi yang tersedia
                      TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              'Jumlah Kursi untuk Jenis Tiket ${index + 1}',
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _controller.jenisTiketSeats.add(int.parse(value!));
                        },
                      ),
                    ],
                  );
                },
              ),
            // Input untuk dana, ovo, gopay, shopeepay, transfer_bank
            TextFormField(
              controller: _controller.danaController,
              decoration: InputDecoration(labelText: 'Dana'),
            ),
            TextFormField(
              controller: _controller.ovoController,
              decoration: InputDecoration(labelText: 'Ovo'),
            ),
            TextFormField(
              controller: _controller.gopayController,
              decoration: InputDecoration(labelText: 'Gopay'),
            ),
            TextFormField(
              controller: _controller.shopeepayController,
              decoration: InputDecoration(labelText: 'Shopeepay'),
            ),
            TextFormField(
              controller: _controller.transferBankController,
              decoration: InputDecoration(labelText: 'Transfer Bank'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_controller.gambar == null
                  ? 'Pilih Gambar'
                  : 'Gambar Terpilih'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Tambah Tiket'),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
