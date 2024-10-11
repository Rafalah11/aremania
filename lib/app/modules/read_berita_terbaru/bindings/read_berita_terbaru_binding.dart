import 'package:get/get.dart';

import '../controllers/read_berita_terbaru_controller.dart';

class ReadBeritaTerbaruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadBeritaTerbaruController>(
      () => ReadBeritaTerbaruController(),
    );
  }
}
