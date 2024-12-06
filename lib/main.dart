// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:myapp/app/controllers/auth_controller.dart';
// import 'package:myapp/app/modules/halaman_animasi_awal/views/halaman_animasi_awal_view.dart';
// import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
// import 'package:myapp/app/modules/home/views/home_view.dart';
// import 'package:myapp/app/modules/ticket_saya/controllers/ticket_saya_controller.dart';
// import 'package:myapp/firebase_options.dart';
// import 'app/routes/app_pages.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   ); // Inisialisasi Firebase

//   // Daftarkan controller
//   Get.put<AuthController>(AuthController());
//   Get.put(TicketSayaController());
//   Get.put(HalamanInformasiPribadiController());

//   // Memeriksa status login pengguna di Firebase
//   User? user = FirebaseAuth.instance.currentUser;

//   // Arahkan pengguna berdasarkan status login mereka
//   runApp(MyApp(user: user));
// }

// class MyApp extends StatelessWidget {
//   final User? user; // Terima status login pengguna

//   MyApp({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Application',
//       initialRoute: user == null
//           ? Routes
//               .HALAMAN_ANIMASI_AWAL // Jika belum login, arahkan ke halaman animasi
//           : Routes.HOME, // Jika sudah login, arahkan ke halaman home
//       getPages: AppPages.routes,
//       home: user == null
//           ? HalamanAnimasiAwalView() // Jika belum login, tampilkan halaman animasi
//           : HomeScreen(), // Jika sudah login, langsung ke halaman home
//     );
//   }
// }
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/halaman_informasi_pribadi/controllers/halaman_informasi_pribadi_controller.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';
import 'package:myapp/app/modules/readdetailartikel/controllers/readdetailartikel_controller.dart';
import 'package:myapp/app/modules/ticket_saya/controllers/ticket_saya_controller.dart';
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
  Get.put(TicketSayaController());
  Get.put(NgalamTerbaruController());
  Get.put(ReaddetailartikelController());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: Routes.HALAMAN_ANIMASI_AWAL,
      getPages: AppPages.routes,
    ),
  );
}
