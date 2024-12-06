import 'package:get/get.dart';

import '../controllers/read_favorite_controller.dart';

class ReadFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReadFavoriteController>(
      () => ReadFavoriteController(),
    );
  }
}
