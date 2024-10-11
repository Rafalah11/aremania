import 'package:get/get.dart';

import '../controllers/arema_read_aremajunior_controller.dart';

class AremaReadAremajuniorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaReadAremajuniorController>(
      () => AremaReadAremajuniorController(),
    );
  }
}
