import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class TicketSayaController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var stadiumLatitude = 0.0.obs;
  var stadiumLongitude = 0.0.obs;
  var address = ''.obs;

  // Fungsi untuk mendapatkan koordinat dari alamat menggunakan OpenCage API
  Future<Map<String, double>> getCoordinatesFromAddress(
      String addressInput) async {
    final apiKey =
        '419aef5d70d64449a1a882ded88bd465'; // Ganti dengan API Key Anda
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$addressInput&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          latitude.value = data['results'][0]['geometry']['lat'];
          longitude.value = data['results'][0]['geometry']['lng'];

          return {
            'latitude': latitude.value,
            'longitude': longitude.value,
          };
        } else {
          // Menampilkan Snackbar jika alamat tidak ditemukan
          Get.snackbar(
            'Koordinat Stadion Tidak Ditemukan',
            'Alamat tidak terdaftar di dalam database API OpenCage.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return {}; // Mengembalikan map kosong jika tidak ditemukan
        }
      } else {
        // Menampilkan Snackbar jika terjadi error dalam mengambil data
        Get.snackbar(
          'Terjadi Kesalahan',
          'Tidak dapat menghubungi server geocoding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return {}; // Mengembalikan map kosong jika terjadi kesalahan
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      // Menampilkan Snackbar jika terjadi kesalahan
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat menghubungi server geocoding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {}; // Mengembalikan map kosong
    }
  }

  // Fungsi untuk mendapatkan lokasi perangkat saat ini
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

  // Fungsi untuk memeriksa izin dan meminta izin lokasi
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
}
