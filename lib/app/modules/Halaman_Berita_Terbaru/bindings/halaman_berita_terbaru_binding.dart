import 'package:get/get.dart';

import '../controllers/halaman_berita_terbaru_controller.dart';

class HalamanBeritaTerbaruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanBeritaTerbaruController>(
      () => HalamanBeritaTerbaruController(),
    );
  }
}
