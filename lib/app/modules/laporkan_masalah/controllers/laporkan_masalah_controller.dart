import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LaporkanMasalahController extends GetxController {
  final description = ''.obs;

  void sendReport() async {
    if (description.value.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('laporan_masalah').add({
          'description': description.value,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Get.snackbar('Sukses', 'Laporan masalah berhasil dikirim',
            snackPosition: SnackPosition.BOTTOM);
        description.value = ''; // Reset field setelah berhasil
      } catch (e) {
        Get.snackbar('Error', 'Gagal mengirim laporan: $e',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Peringatan', 'Deskripsi tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
