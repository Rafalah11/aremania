import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/views/halaman_edit_informasi_pribadi_view.dart';
import 'package:path/path.dart';

class HalamanInformasiPribadiController extends GetxController {
  var nama = ''.obs;
  var jenisKelamin = ''.obs;
  var tanggalLahir = ''.obs;
  var nomorHandphone = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs; // URL foto profil

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    String? userId = getCurrentUserId();
    if (userId != null) {
      checkUserData(userId);
    }
  }

  Future<void> pickProfileImage(String userId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await uploadProfileImage(File(image.path), userId);

      // Berikan jeda untuk pembaruan
      await Future.delayed(Duration(milliseconds: 500));
      photoUrl.refresh();

      // Tampilkan snackbar
      Get.snackbar("Sukses", "Foto profil berhasil diunggah!");

      // Kembali ke halaman sebelumnya
      Get.back();
    }
  }

  Future<void> uploadProfileImage(File imageFile, String userId) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId/$fileName');

      // Unggah gambar
      await storageRef.putFile(imageFile);

      // Ambil URL setelah diunggah
      String downloadUrl = await storageRef.getDownloadURL();
      photoUrl.value = '$downloadUrl?${DateTime.now().millisecondsSinceEpoch}';

      // Print untuk memastikan downloadUrl telah diperbarui
      print('URL baru untuk foto profil: $downloadUrl');

      // Simpan URL di Firestore
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .set({'photo_url': downloadUrl}, SetOptions(merge: true));

      print('Foto profil berhasil diunggah.');
    } catch (e) {
      print('Error mengunggah foto profil: $e');
      Get.snackbar("Error", "Gagal mengunggah foto profil: $e");
    }
  }

  Future<void> checkUserData(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .get();
    if (doc.exists) {
      photoUrl.value = doc['photo_url'] ?? '';
      nama.value = doc['nama'] ?? '';
      jenisKelamin.value = doc['jenis_kelamin'] ?? '';
      tanggalLahir.value = doc['tanggal_lahir'] ?? '';
      nomorHandphone.value = doc['nomor_handphone'] ?? '';
      email.value = doc['email'] ?? '';
    } else {
      Get.to(HalamanEditInformasiPribadiView(userId: userId, isNewUser: true));
    }
  }

  Future<void> loadUserData() async {
    String? userId = getCurrentUserId();

    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .get();

      if (doc.exists) {
        photoUrl.value = doc['photo_url'] ?? '';
        nama.value = doc['nama'] ?? '';
        jenisKelamin.value = doc['jenis_kelamin'] ?? '';
        tanggalLahir.value = doc['tanggal_lahir'] ?? '';
        nomorHandphone.value = doc['nomor_handphone'] ?? '';
        email.value = doc['email'] ?? '';
      } else {
        Get.to(
            HalamanEditInformasiPribadiView(userId: userId, isNewUser: true));
      }
    }
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> saveDataToFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('profile').doc(userId).set({
        'photo_url':
            photoUrl.value, // Pastikan konsisten menggunakan 'photo_url'
        'nama': nama.value,
        'jenis_kelamin': jenisKelamin.value,
        'tanggal_lahir': tanggalLahir.value,
        'nomor_handphone': nomorHandphone.value,
        'email': email.value,
      });
      print('Data berhasil disimpan.');
    } catch (e) {
      print('Error menyimpan data: $e');
    }
  }
}
