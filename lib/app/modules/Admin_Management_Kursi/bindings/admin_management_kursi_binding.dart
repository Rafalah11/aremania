import 'package:get/get.dart';

import '../controllers/admin_management_kursi_controller.dart';

class AdminManagementKursiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManagementKursiController>(
      () => AdminManagementKursiController(),
    );
  }
}
