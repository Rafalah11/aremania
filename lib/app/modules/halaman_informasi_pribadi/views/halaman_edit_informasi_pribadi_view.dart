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
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.photoUrl.value.isNotEmpty
                        ? NetworkImage(controller.photoUrl.value)
                        : const AssetImage('assets/gambar1.jpeg')
                            as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          const SizedBox(height: 20), // Ruang kosong sebelum form
          _buildTextField('Nama', controller.nama),
          _buildTextField('Jenis Kelamin', controller.jenisKelamin),
          _buildTextField('Tanggal Lahir', controller.tanggalLahir),
          _buildTextField('No. Handphone', controller.nomorHandphone),
          _buildTextField('Email', controller.email),
          const SizedBox(height: 20), // Ruang kosong sebelum tombol
          ElevatedButton(
            onPressed: () async {
              await controller.saveDataToFirestore(userId);
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
          Text(title, style: const TextStyle(fontSize: 16)),
          Obx(() => TextField(
                onChanged: (value) => controllerValue.value = value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Masukkan $title',
                  labelText: controllerValue.value.isNotEmpty ? title : null,
                ),
              )),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromCamera(userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih Foto dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickProfileImage(userId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
