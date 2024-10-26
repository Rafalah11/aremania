import 'package:get/get.dart';

import '../controllers/halaman_profile_controller.dart';

class HalamanProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanProfileController>(
      () => HalamanProfileController(),
    );
  }
}
