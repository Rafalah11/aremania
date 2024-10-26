import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inisialisasi Firebase

  // Daftarkan AuthController secara langsung
  Get.put<AuthController>(AuthController());

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.HALAMAN_ANIMASI_AWAL,
      getPages: AppPages.routes,
    ),
  );
}
