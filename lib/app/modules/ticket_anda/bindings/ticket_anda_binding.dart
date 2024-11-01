import 'package:get/get.dart';

import '../controllers/ticket_anda_controller.dart';

class TicketAndaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketAndaController>(
      () => TicketAndaController(),
    );
  }
}
