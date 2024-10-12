import 'package:get/get.dart';

import '../controllers/ngalam_malangan_controller.dart';

class NgalamMalanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamMalanganController>(
      () => NgalamMalanganController(),
    );
  }
}
