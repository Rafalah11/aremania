import 'package:get/get.dart';

import '../controllers/rincian_ticket_controller.dart';

class RincianTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RincianTicketController>(
      () => RincianTicketController(),
    );
  }
}
