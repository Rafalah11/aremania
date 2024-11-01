import 'package:get/get.dart';
import 'package:myapp/app/modules/admin_informasi/controllers/admin_informasi_controller.dart';

class AdminInformasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminInformasiController>(
      () => AdminInformasiController(),
    );
  }
}
