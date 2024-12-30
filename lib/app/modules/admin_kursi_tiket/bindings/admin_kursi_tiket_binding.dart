import 'package:get/get.dart';

import '../controllers/admin_kursi_tiket_controller.dart';

class AdminKursiTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminKursiTiketController>(
      () => AdminKursiTiketController(),
    );
  }
}
