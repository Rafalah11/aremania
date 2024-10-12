import 'package:get/get.dart';

import '../controllers/ngalam_destinasi_controller.dart';

class NgalamDestinasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamDestinasiController>(
      () => NgalamDestinasiController(),
    );
  }
}
