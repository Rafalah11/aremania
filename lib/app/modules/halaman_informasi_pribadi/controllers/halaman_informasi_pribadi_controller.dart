import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:path/path.dart';

class HalamanInformasiPribadiController extends GetxController {
  var nama = ''.obs;
  var jenisKelamin = ''.obs;
  var tanggalLahir = ''.obs;
  var nomorHandphone = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs; // URL foto profil

  final ImagePicker _picker = ImagePicker();

  var isEditing = false.obs;
  var originalData = {}.obs;
  Map<String, TextEditingController> textControllers = {};
  var isUploading = false.obs;

  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }

  TextEditingController getTextController(String key, String initialValue) {
    if (!textControllers.containsKey(key)) {
      textControllers[key] = TextEditingController(text: initialValue);
    }
    return textControllers[key]!;
  }

  void showImageSourceDialog(String userId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              const Color.fromARGB(221, 188, 188, 188)
            ], // Gradasi warna
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Sumber Foto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Warna teks judul
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.white, // Warna icon
              ),
              title: Text(
                'Ambil Foto dari Kamera',
                style: TextStyle(color: Colors.white), // Warna teks
              ),
              onTap: () {
                pickImageFromCamera(userId);
                Get.back();
              },
            ),
            Divider(color: Colors.white.withOpacity(0.5)),
            ListTile(
              leading: Icon(
                Icons.photo,
                color: Colors.white, // Warna icon
              ),
              title: Text(
                'Pilih Foto dari Galeri',
                style: TextStyle(color: Colors.white), // Warna teks
              ),
              onTap: () {
                pickProfileImage(userId);
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Memastikan dialog bisa disesuaikan ukurannya
    );
  }

  Future<void> pickProfileImage(String userId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await uploadProfileImage(File(image.path), userId);
    }
  }

  Future<void> pickImageFromCamera(String userId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await uploadProfileImage(File(image.path), userId);
    }
  }

  Future<void> uploadProfileImage(File imageFile, String userId) async {
    try {
      isUploading.value = true; // Mulai loading
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId/$fileName');

      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();
      photoUrl.value = '$downloadUrl?${DateTime.now().millisecondsSinceEpoch}';

      await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .set({'photo_url': downloadUrl}, SetOptions(merge: true));
    } catch (e) {
      print('Error mengunggah foto profil: $e');
      Get.snackbar("Error", "Gagal mengunggah foto profil: $e");
    } finally {
      isUploading.value = false; // Akhiri loading
    }
  }

  // Menyimpan data profil yang diubah
  Future<void> saveProfileData() async {
    String? userId = getCurrentUserId();
    if (userId != null) {
      await FirebaseFirestore.instance.collection('profile').doc(userId).set({
        'nama': nama.value,
        'jenis_kelamin': jenisKelamin.value,
        'tanggal_lahir': tanggalLahir.value,
        'nomor_handphone': nomorHandphone.value,
        'email': email.value,
        'photo_url': photoUrl.value,
      }, SetOptions(merge: true));

      Get.snackbar(
        "Sukses",
        "Profil berhasil disimpan!",
        backgroundColor: Colors.green,
        colorText:
            Colors.white, // Mengubah warna teks menjadi putih agar kontras
        snackPosition: SnackPosition.TOP, // Atur posisi snackbar (opsional)
        borderRadius: 10, // Tambahkan radius agar lebih estetis
        margin: EdgeInsets.all(10), // Atur margin
      );

      toggleEditMode(); // Exit from edit mode
    }
  }

  Future<void> checkUserData(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .get();
    if (doc.exists) {
      // Memperbarui nilai observables dengan data dari Firebase
      photoUrl.value = doc['photo_url'] ?? '';
      nama.value = doc['nama'] ?? '';
      jenisKelamin.value = doc['jenis_kelamin'] ?? '';
      tanggalLahir.value = doc['tanggal_lahir'] ?? '';
      nomorHandphone.value = doc['nomor_handphone'] ?? '';
      email.value = doc['email'] ?? '';

      // Simpan data asli agar bisa digunakan ketika membatalkan edit
      originalData.value = {
        'photo_url': photoUrl.value,
        'nama': nama.value,
        'jenis_kelamin': jenisKelamin.value,
        'tanggal_lahir': tanggalLahir.value,
        'nomor_handphone': nomorHandphone.value,
        'email': email.value,
      };
    }
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}
