import 'package:get/get.dart';

import '../controllers/arema_beritafoto_controller.dart';

class AremaBeritafotoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaBeritafotoController>(
      () => AremaBeritafotoController(),
    );
  }
}
