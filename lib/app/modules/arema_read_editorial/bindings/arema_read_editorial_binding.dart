import 'package:get/get.dart';

import '../controllers/arema_read_editorial_controller.dart';

class AremaReadEditorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaReadEditorialController>(
      () => AremaReadEditorialController(),
    );
  }
}
