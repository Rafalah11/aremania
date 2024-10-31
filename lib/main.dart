// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
import 'package:myapp/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inisialisasi Firebase
  // await FirebaseAppCheck.instance.activate();

  // Daftarkan Controller secara langsung
  Get.put<AuthController>(AuthController());
  Get.put<HalamanInformasiPribadiController>(
      HalamanInformasiPribadiController());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.HALAMAN_ANIMASI_AWAL,
      getPages: AppPages.routes,
    ),
  );
}
