import 'package:get/get.dart';

import '../controllers/ngalam_read_info_penting_controller.dart';

class NgalamReadInfoPentingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamReadInfoPentingController>(
      () => NgalamReadInfoPentingController(),
    );
  }
}
