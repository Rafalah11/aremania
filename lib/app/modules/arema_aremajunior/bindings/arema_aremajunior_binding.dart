import 'package:get/get.dart';

import '../controllers/arema_aremajunior_controller.dart';

class AremaAremajuniorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaAremajuniorController>(
      () => AremaAremajuniorController(),
    );
  }
}
