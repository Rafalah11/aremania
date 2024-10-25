import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.HALAMAN_DAFTAR,
      getPages: AppPages.routes,
    ),
  );
}
