import 'package:get/get.dart';

import '../controllers/ngalam_terbaru_controller.dart';

class NgalamTerbaruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamTerbaruController>(
      () => NgalamTerbaruController(),
    );
  }
}
