import 'package:get/get.dart';

import '../controllers/read_aremaday_controller.dart';

class ReadAremadayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadAremadayController>(
      () => ReadAremadayController(),
    );
  }
}
