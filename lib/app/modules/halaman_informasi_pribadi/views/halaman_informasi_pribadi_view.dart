import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/views/halaman_edit_informasi_pribadi_view.dart';

class HalamanInformasiPribadiView extends StatelessWidget {
  final HalamanInformasiPribadiController controller =
      Get.put(HalamanInformasiPribadiController());

  @override
  Widget build(BuildContext context) {
    // Memanggil loadUserData untuk memuat data pengguna saat halaman dibuka
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Ubah Profil', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        // Cek apakah data user sudah lengkap atau belum
        if (controller.nama.value.isEmpty) {
          // Jika data belum diisi, arahkan ke halaman edit
          return Center(
            child: ElevatedButton(
              onPressed: () {
                String? userId = controller.getCurrentUserId();
                if (userId != null) {
                  Get.to(HalamanEditInformasiPribadiView(
                    userId: userId,
                    isNewUser:
                        true, // Tampilkan halaman edit untuk pengisian data
                  ));
                } else {
                  Get.snackbar(
                      'Error', 'User tidak ditemukan. Silakan login ulang.');
                }
              },
              child: Text('Isi Data Pribadi'),
            ),
          );
        }

        // Jika data sudah ada, tampilkan halaman informasi pribadi
        return Column(
          children: [
            Container(
              color: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Obx(() => CircleAvatar(
                          radius: 40,
                          backgroundImage: controller.photoUrl.value.isNotEmpty
                              ? NetworkImage(controller.photoUrl.value)
                              : AssetImage('assets/gambar1.jpeg')
                                  as ImageProvider, // Tampilkan gambar default jika URL kosong
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildTextField('Nama', controller.nama),
                  _buildTextField('Jenis Kelamin', controller.jenisKelamin),
                  _buildTextField('Tanggal Lahir', controller.tanggalLahir),
                  _buildTextField('No. Handphone', controller.nomorHandphone),
                  _buildTextField('Email', controller.email),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String? userId = controller.getCurrentUserId();
                if (userId != null) {
                  Get.to(HalamanEditInformasiPribadiView(
                    userId: userId,
                    isNewUser: controller.nama.value.isEmpty,
                  ));
                } else {
                  Get.snackbar(
                      'Error', 'User tidak ditemukan. Silakan login ulang.');
                }
              },
              child: Obx(() => Text(
                    controller.nama.value.isEmpty ? 'Isi Data' : 'Edit Profile',
                  )),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField(String title, RxString controllerValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Obx(
            () => AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan $title',
                  labelText: controllerValue.value,
                ),
                readOnly: true, // Membuat TextField tidak dapat diedit
              ),
            ),
          ),
        ],
      ),
    );
  }
}
