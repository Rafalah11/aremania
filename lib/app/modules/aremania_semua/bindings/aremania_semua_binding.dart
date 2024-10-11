import 'package:get/get.dart';

import '../controllers/aremania_semua_controller.dart';

class AremaniaSemuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AremaniaSemuaController>(
      () => AremaniaSemuaController(),
    );
  }
}
