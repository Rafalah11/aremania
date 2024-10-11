import 'package:get/get.dart';

import '../controllers/trending_semua_controller.dart';

class TrendingSemuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrendingSemuaController>(
      () => TrendingSemuaController(),
    );
  }
}
