import 'package:get/get.dart';

import '../controllers/admin_tiket_controller.dart';

class AdminTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminTiketController>(
      () => AdminTiketController(),
    );
  }
}
