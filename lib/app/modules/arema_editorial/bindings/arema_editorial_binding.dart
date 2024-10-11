import 'package:get/get.dart';

import '../controllers/arema_editorial_controller.dart';

class AremaEditorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaEditorialController>(
      () => AremaEditorialController(),
    );
  }
}
