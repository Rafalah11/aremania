import 'package:get/get.dart';

import '../controllers/halaman_animasi_awal_controller.dart';

class HalamanAnimasiAwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanAnimasiAwalController>(
      () => HalamanAnimasiAwalController(),
    );
  }
}
