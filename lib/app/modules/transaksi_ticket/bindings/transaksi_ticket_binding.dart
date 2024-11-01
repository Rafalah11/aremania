import 'package:get/get.dart';

import '../controllers/transaksi_ticket_controller.dart';

class TransaksiTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransaksiTicketController>(
      () => TransaksiTicketController(),
    );
  }
}
