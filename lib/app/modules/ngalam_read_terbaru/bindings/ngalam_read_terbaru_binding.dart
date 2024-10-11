import 'package:get/get.dart';

import '../controllers/ngalam_read_terbaru_controller.dart';

class NgalamReadTerbaruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamReadTerbaruController>(
      () => NgalamReadTerbaruController(),
    );
  }
}
