import 'package:get/get.dart';

import '../controllers/read_aremania_controller.dart';

class ReadAremaniaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadAremaniaController>(
      () => ReadAremaniaController(),
    );
  }
}
