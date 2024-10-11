import 'package:get/get.dart';

import '../controllers/read_trending_controller.dart';

class ReadTrendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadTrendingController>(
      () => ReadTrendingController(),
    );
  }
}
