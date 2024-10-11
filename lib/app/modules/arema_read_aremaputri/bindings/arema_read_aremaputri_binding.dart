import 'package:get/get.dart';

import '../controllers/arema_read_aremaputri_controller.dart';

class AremaReadAremaputriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaReadAremaputriController>(
      () => AremaReadAremaputriController(),
    );
  }
}
