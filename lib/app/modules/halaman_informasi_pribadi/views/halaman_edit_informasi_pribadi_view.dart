import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';

class HalamanEditInformasiPribadiView extends StatelessWidget {
  final String userId;
  final bool isNewUser;

  HalamanEditInformasiPribadiView(
      {required this.userId, this.isNewUser = false});

  final HalamanInformasiPribadiController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(isNewUser ? 'Isi Data Awal' : 'Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => controller.pickProfileImage(userId),
              child: Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.photoUrl.value.isNotEmpty
                        ? NetworkImage(controller.photoUrl.value)
                        : AssetImage('assets/gambar1.jpeg') as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ),
          SizedBox(height: 20), // Ruang kosong sebelum form
          _buildTextField('Nama', controller.nama),
          _buildTextField('Jenis Kelamin', controller.jenisKelamin),
          _buildTextField('Tanggal Lahir', controller.tanggalLahir),
          _buildTextField('No. Handphone', controller.nomorHandphone),
          _buildTextField('Email', controller.email),
          SizedBox(height: 20), // Ruang kosong sebelum tombol
          ElevatedButton(
            onPressed: () {
              controller.saveDataToFirestore(userId);
              if (isNewUser) {
                Get.back();
              }
            },
            child: Text(isNewUser ? 'Simpan Data' : 'Update Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String title, RxString controllerValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Obx(() => TextField(
                onChanged: (value) {
                  controllerValue.value = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan $title',
                  labelText: controllerValue.value,
                ),
              )),
        ],
      ),
    );
  }
}
