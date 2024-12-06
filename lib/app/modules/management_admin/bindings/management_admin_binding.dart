import 'package:get/get.dart';

import '../controllers/management_admin_controller.dart';

class ManagementAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagementAdminController>(
      () => ManagementAdminController(),
    );
  }
}
