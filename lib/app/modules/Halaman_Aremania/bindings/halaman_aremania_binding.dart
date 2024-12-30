import 'package:get/get.dart';

import '../controllers/halaman_aremania_controller.dart';

class HalamanAremaniaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanAremaniaController>(
      () => HalamanAremaniaController(),
    );
  }
}
