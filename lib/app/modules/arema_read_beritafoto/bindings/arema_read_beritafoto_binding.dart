import 'package:get/get.dart';

import '../controllers/arema_read_beritafoto_controller.dart';

class AremaReadBeritafotoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaReadBeritafotoController>(
      () => AremaReadBeritafotoController(),
    );
  }
}
