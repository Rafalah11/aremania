import 'package:get/get.dart';

import '../controllers/readdetailartikel_controller.dart';

class ReaddetailartikelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaddetailartikelController>(
      () => ReaddetailartikelController(),
    );
  }
}
