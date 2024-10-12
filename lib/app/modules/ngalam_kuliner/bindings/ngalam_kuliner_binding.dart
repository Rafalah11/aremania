import 'package:get/get.dart';

import '../controllers/ngalam_kuliner_controller.dart';

class NgalamKulinerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NgalamKulinerController>(
      () => NgalamKulinerController(),
    );
  }
}
