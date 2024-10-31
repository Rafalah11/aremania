import 'package:get/get.dart';

import '../controllers/kata_sandi_controller.dart';

class KataSandiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KataSandiController>(
      () => KataSandiController(),
    );
  }
}
