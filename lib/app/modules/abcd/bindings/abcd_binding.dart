import 'package:get/get.dart';

import '../controllers/abcd_controller.dart';

class AbcdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbcdController>(
      () => AbcdController(),
    );
  }
}
