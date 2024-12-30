import 'package:get/get.dart';

import '../controllers/halaman_arema_day_controller.dart';

class HalamanAremaDayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanAremaDayController>(
      () => HalamanAremaDayController(),
    );
  }
}
