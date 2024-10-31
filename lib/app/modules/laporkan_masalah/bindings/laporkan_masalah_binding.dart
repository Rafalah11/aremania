import 'package:get/get.dart';

import '../controllers/laporkan_masalah_controller.dart';

class LaporkanMasalahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaporkanMasalahController>(
      () => LaporkanMasalahController(),
    );
  }
}
