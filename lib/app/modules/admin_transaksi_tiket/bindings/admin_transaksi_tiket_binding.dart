import 'package:get/get.dart';

import '../controllers/admin_transaksi_tiket_controller.dart';

class AdminTransaksiTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminTransaksiTiketController>(
      () => AdminTransaksiTiketController(),
    );
  }
}
