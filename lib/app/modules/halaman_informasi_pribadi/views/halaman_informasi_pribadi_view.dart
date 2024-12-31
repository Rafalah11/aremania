import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';

class HalamanInformasiPribadiView extends StatelessWidget {
  final HalamanInformasiPribadiController controller =
      Get.put(HalamanInformasiPribadiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Pribadi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[200], // Warna abu-abu untuk latar belakang
        child: Column(
          children: [
            Expanded(
              // Menambahkan Expanded di sini agar warna abu-abu mengisi ruang bawah
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Obx(() => GestureDetector(
                          onTap: controller.isEditing.value
                              ? () => controller.showImageSourceDialog(
                                  controller.getCurrentUserId() ?? '')
                              : null,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey,
                                backgroundImage: controller
                                        .photoUrl.value.isNotEmpty
                                    ? NetworkImage(controller.photoUrl.value)
                                    : null,
                                child: controller.photoUrl.value.isEmpty
                                    ? Icon(Icons.person,
                                        size: 50, color: Colors.white)
                                    : null,
                              ),
                              if (controller.isEditing.value)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.white),
                                  ),
                                ),
                              if (controller.isUploading
                                  .value) // Tampilkan loading jika true
                                CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                            ],
                          ),
                        )),
                    SizedBox(height: 16),
                    _buildTextField('Nama', controller.nama),
                    _buildTextField('Jenis Kelamin', controller.jenisKelamin),
                    _buildTextField('Tanggal Lahir', controller.tanggalLahir),
                    _buildTextField(
                        'Nomor Handphone', controller.nomorHandphone),
                    _buildTextField('Email', controller.email),
                    SizedBox(height: 30),
                    Obx(() => controller.isEditing.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.toggleEditMode(); // Exit edit mode
                                },
                                child: Text(
                                  'Batal Edit',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.saveProfileData(); // Simpan data
                                },
                                child: Text(
                                  'Simpan Data',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: controller.toggleEditMode,
                            child: Text(
                              'Edit Data',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String title, RxString controllerValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Obx(() {
            if (title == 'Jenis Kelamin') {
              // Dropdown untuk Jenis Kelamin
              final options = ['Pria', 'Wanita'];
              // Pastikan nilai default sesuai dengan opsi yang ada
              if (!options.contains(controllerValue.value)) {
                controllerValue.value = ''; // Set nilai kosong jika tidak cocok
              }

              return DropdownButtonFormField<String>(
                value: controllerValue.value.isEmpty
                    ? null
                    : controllerValue.value,
                items: options
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: controller.isEditing.value
                    ? (value) {
                        if (value != null) controllerValue.value = value;
                      }
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              );
            } else if (title == 'Tanggal Lahir') {
              // Date Picker untuk Tanggal Lahir
              return TextField(
                controller: TextEditingController(text: controllerValue.value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  hintText: 'Pilih Tanggal Lahir',
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon:
                      Icon(Icons.calendar_today, color: Colors.blueAccent),
                ),
                readOnly: true, // Agar tidak bisa mengetik secara manual
                onTap: controller.isEditing.value
                    ? () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          controllerValue.value =
                              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                        }
                      }
                    : null,
              );
            } else {
              // Default TextField
              final textController =
                  controller.getTextController(title, controllerValue.value);
              return TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  hintText: 'Masukkan $title',
                  fillColor: Colors.white,
                  filled: true,
                ),
                readOnly: !controller.isEditing.value,
                onChanged: (value) {
                  controllerValue.value = value;
                },
              );
            }
          }),
        ],
      ),
    );
  }
}
