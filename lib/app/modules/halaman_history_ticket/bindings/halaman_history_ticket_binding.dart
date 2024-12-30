import 'package:get/get.dart';

import '../controllers/halaman_history_ticket_controller.dart';

class HalamanHistoryTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanHistoryTicketController>(
      () => HalamanHistoryTicketController(),
    );
  }
}
