import 'package:get/get.dart';

import '../controllers/arema_aremaputri_controller.dart';

class AremaAremaputriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaAremaputriController>(
      () => AremaAremaputriController(),
    );
  }
}
