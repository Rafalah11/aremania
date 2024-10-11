import 'package:get/get.dart';

import '../controllers/aremaday_semua_controller.dart';

class AremadaySemuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremadaySemuaController>(
      () => AremadaySemuaController(),
    );
  }
}
