import 'package:get/get.dart';

import '../controllers/ubah_kata_sandi_controller.dart';

class UbahKataSandiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbahKataSandiController>(
      () => UbahKataSandiController(),
    );
  }
}
