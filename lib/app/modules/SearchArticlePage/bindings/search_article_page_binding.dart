import 'package:get/get.dart';

import '../controllers/search_article_page_controller.dart';

class SearchArticlePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchArticlePageController>(
      () => SearchArticlePageController(),
    );
  }
}
