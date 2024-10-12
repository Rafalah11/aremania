import 'package:get/get.dart';

import '../controllers/ngalam_infopenting_controller.dart';

class NgalamInfopentingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamInfopentingController>(
      () => NgalamInfopentingController(),
    );
  }
}
