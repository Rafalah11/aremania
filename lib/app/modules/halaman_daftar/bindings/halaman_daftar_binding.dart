import 'package:get/get.dart';

import '../controllers/halaman_daftar_controller.dart';

class HalamanDaftarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanDaftarController>(
      () => HalamanDaftarController(),
    );
  }
}
