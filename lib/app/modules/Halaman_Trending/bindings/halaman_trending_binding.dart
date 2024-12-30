import 'package:get/get.dart';

import '../controllers/halaman_trending_controller.dart';

class HalamanTrendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanTrendingController>(
      () => HalamanTrendingController(),
    );
  }
}
