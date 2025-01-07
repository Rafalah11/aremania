import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HalamanHistoryTicketController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Jika izin diberikan, dapatkan lokasi perangkat
      await getCurrentLocation();
    } else if (status.isDenied) {
      // Jika izin ditolak, minta ulang izin
      Get.snackbar(
        'Izin Diperlukan',
        'Untuk melanjutkan, izinkan aplikasi mengakses lokasi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (status.isPermanentlyDenied) {
      // Jika izin ditolak secara permanen, arahkan ke pengaturan
      openAppSettings();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Debug print coordinates
      print('Latitude: ${latitude.value}, Longitude: ${longitude.value}');
    } catch (e) {
      print("Gagal mendapatkan lokasi: $e");
      Get.snackbar(
        'Lokasi Tidak Ditemukan',
        'Gagal mendapatkan lokasi saat ini.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
