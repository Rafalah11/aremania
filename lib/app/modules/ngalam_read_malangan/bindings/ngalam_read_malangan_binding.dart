import 'package:get/get.dart';

import '../controllers/ngalam_read_malangan_controller.dart';

class NgalamReadMalanganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamReadMalanganController>(
      () => NgalamReadMalanganController(),
    );
  }
}
