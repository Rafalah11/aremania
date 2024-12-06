import 'package:get/get.dart';

import '../controllers/ticket_saya_controller.dart';

class TicketSayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketSayaController>(
      () => TicketSayaController(),
    );
  }
}
