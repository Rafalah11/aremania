import 'package:get/get.dart';

import '../controllers/ngalam_read_malangankuliner_controller.dart';

class NgalamReadMalangankulinerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamReadMalangankulinerController>(
      () => NgalamReadMalangankulinerController(),
    );
  }
}
