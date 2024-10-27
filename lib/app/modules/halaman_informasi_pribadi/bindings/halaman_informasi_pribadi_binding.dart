import 'package:get/get.dart';

import '../controllers/halaman_informasi_pribadi_controller.dart';

class HalamanInformasiPribadiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanInformasiPribadiController>(
      () => HalamanInformasiPribadiController(),
    );
  }
}
