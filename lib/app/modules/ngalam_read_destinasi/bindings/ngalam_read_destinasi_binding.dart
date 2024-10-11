import 'package:get/get.dart';

import '../controllers/ngalam_read_destinasi_controller.dart';

class NgalamReadDestinasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamReadDestinasiController>(
      () => NgalamReadDestinasiController(),
    );
  }
}
