import 'package:get/get.dart';

import '../modules/News_page/bindings/news_page_binding.dart';
import '../modules/News_page/views/news_page_view.dart';
import '../modules/arema_aremajunior/bindings/arema_aremajunior_binding.dart';
import '../modules/arema_aremajunior/views/arema_aremajunior_view.dart';
import '../modules/arema_aremaputri/bindings/arema_aremaputri_binding.dart';
import '../modules/arema_aremaputri/views/arema_aremaputri_view.dart';
import '../modules/arema_beritafoto/bindings/arema_beritafoto_binding.dart';
import '../modules/arema_beritafoto/views/arema_beritafoto_view.dart';
import '../modules/arema_editorial/bindings/arema_editorial_binding.dart';
import '../modules/arema_editorial/views/arema_editorial_view.dart';
import '../modules/arema_read_aremajunior/bindings/arema_read_aremajunior_binding.dart';
import '../modules/arema_read_aremajunior/views/arema_read_aremajunior_view.dart';
import '../modules/arema_read_aremaputri/bindings/arema_read_aremaputri_binding.dart';
import '../modules/arema_read_aremaputri/views/arema_read_aremaputri_view.dart';
import '../modules/arema_read_beritafoto/bindings/arema_read_beritafoto_binding.dart';
import '../modules/arema_read_beritafoto/views/arema_read_beritafoto_view.dart';
import '../modules/arema_read_editorial/bindings/arema_read_editorial_binding.dart';
import '../modules/arema_read_editorial/views/arema_read_editorial_view.dart';
import '../modules/aremaday_semua/bindings/aremaday_semua_binding.dart';
import '../modules/aremaday_semua/views/aremaday_semua_view.dart';
import '../modules/aremania_semua/bindings/aremania_semua_binding.dart';
import '../modules/aremania_semua/views/aremania_semua_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/ngalam_read_destinasi/bindings/ngalam_read_destinasi_binding.dart';
import '../modules/ngalam_read_destinasi/views/ngalam_read_destinasi_view.dart';
import '../modules/ngalam_read_info_penting/bindings/ngalam_read_info_penting_binding.dart';
import '../modules/ngalam_read_info_penting/views/ngalam_read_info_penting_view.dart';
import '../modules/ngalam_read_malangan/bindings/ngalam_read_malangan_binding.dart';
import '../modules/ngalam_read_malangan/views/ngalam_read_malangan_view.dart';
import '../modules/ngalam_read_malangankuliner/bindings/ngalam_read_malangankuliner_binding.dart';
import '../modules/ngalam_read_malangankuliner/views/ngalam_read_malangankuliner_view.dart';
import '../modules/ngalam_read_terbaru/bindings/ngalam_read_terbaru_binding.dart';
import '../modules/ngalam_read_terbaru/views/ngalam_read_terbaru_view.dart';
import '../modules/ngalam_terbaru/bindings/ngalam_terbaru_binding.dart';
import '../modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import '../modules/read_aremaday/bindings/read_aremaday_binding.dart';
import '../modules/read_aremaday/views/read_aremaday_view.dart';
import '../modules/read_aremania/bindings/read_aremania_binding.dart';
import '../modules/read_aremania/views/read_aremania_view.dart';
import '../modules/read_berita_terbaru/bindings/read_berita_terbaru_binding.dart';
import '../modules/read_berita_terbaru/views/read_berita_terbaru_view.dart';
import '../modules/read_trending/bindings/read_trending_binding.dart';
import '../modules/read_trending/views/read_trending_view.dart';
import '../modules/trending_semua/bindings/trending_semua_binding.dart';
import '../modules/trending_semua/views/trending_semua_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const NEWS_PAGE = Routes.NEWS_PAGE;
  static const AREMADAY_SEMUA = Routes.AREMADAY_SEMUA;
  static const AREMANIA_SEMUA = Routes.AREMANIA_SEMUA;
  static const TRENDING_SEMUA = Routes.TRENDING_SEMUA;
  static const READ_BERITA_TERBARU = Routes.READ_BERITA_TERBARU;
  static const READ_TRENDING = Routes.READ_TRENDING;
  static const READ_AREMADAY = Routes.READ_AREMADAY;
  static const READ_AREMANIA = Routes.READ_AREMANIA;
  static const NGALAM_TERBARU = Routes.NGALAM_TERBARU;
  static const NGALAM_READ_TERBARU = Routes.NGALAM_READ_TERBARU;
  static const NGALAM_READ_DESTINASI = Routes.NGALAM_READ_DESTINASI;
  static const NGALAM_READ_MALANGAN = Routes.NGALAM_READ_MALANGAN;
  static const NGALAM_READ_MALANGANKULINER = Routes.NGALAM_READ_MALANGANKULINER;
  static const NGALAM_READ_INFO_PENTING = Routes.NGALAM_READ_INFO_PENTING;
  static const AREMA_READ_BERITAFOTO = Routes.AREMA_READ_BERITAFOTO;
  static const AREMA_READ_AREMAJUNIOR = Routes.AREMA_READ_AREMAJUNIOR;
  static const AREMA_READ_AREMAPUTRI = Routes.AREMA_READ_AREMAPUTRI;
  static const AREMA_READ_EDITORIAL = Routes.AREMA_READ_EDITORIAL;
  static const AREMA_AREMAJUNIOR = Routes.AREMA_AREMAJUNIOR;
  static const AREMA_AREMAPUTRI = Routes.AREMA_AREMAPUTRI;
  static const AREMA_BERITAFOTO = Routes.AREMA_BERITAFOTO;
  static const AREMA_EDITORIAL = Routes.AREMA_EDITORIAL;


  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_PAGE,
      page: () => NewsPage(),
      binding: NewsPageBinding(),
    ),
    GetPage(
      name: _Paths.TRENDING_SEMUA,
      page: () => TrendingSemuaView(),
      binding: TrendingSemuaBinding(),
    ),
    GetPage(
      name: _Paths.AREMADAY_SEMUA,
      page: () => AremadaySemuaView(),
      binding: AremadaySemuaBinding(),
    ),
    GetPage(
      name: _Paths.AREMANIA_SEMUA,
      page: () => AremaniaSemuaView(),
      binding: AremaniaSemuaBinding(),
    ),
    GetPage(
      name: _Paths.READ_BERITA_TERBARU,
      page: () => ReadBeritaTerbaruView(),
      binding: ReadBeritaTerbaruBinding(),
    ),
    GetPage(
      name: _Paths.READ_TRENDING,
      page: () => ReadTrendingView(),
      binding: ReadTrendingBinding(),
    ),
    GetPage(
      name: _Paths.READ_AREMADAY,
      page: () => ReadAremadayView(),
      binding: ReadAremadayBinding(),
    ),
    GetPage(
      name: _Paths.READ_AREMANIA,
      page: () => ReadAremaniaView(),
      binding: ReadAremaniaBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_TERBARU,
      page: () => NgalamTerbaruView(),
      binding: NgalamTerbaruBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_READ_TERBARU,
      page: () => NgalamReadTerbaruView(),
      binding: NgalamReadTerbaruBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_READ_DESTINASI,
      page: () => NgalamReadDestinasiView(),
      binding: NgalamReadDestinasiBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_READ_MALANGAN,
      page: () => NgalamReadMalanganView(),
      binding: NgalamReadMalanganBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_READ_MALANGANKULINER,
      page: () => NgalamReadMalangankulinerView(),
      binding: NgalamReadMalangankulinerBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_READ_INFO_PENTING,
      page: () => NgalamReadInfoPentingView(),
      binding: NgalamReadInfoPentingBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_READ_EDITORIAL,
      page: () => AremaReadEditorialView(),
      binding: AremaReadEditorialBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_READ_AREMAPUTRI,
      page: () => AremaReadAremaputriView(),
      binding: AremaReadAremaputriBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_READ_AREMAJUNIOR,
      page: () => AremaReadAremajuniorView(),
      binding: AremaReadAremajuniorBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_READ_BERITAFOTO,
      page: () => AremaReadBeritafotoView(),
      binding: AremaReadBeritafotoBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_EDITORIAL,
      page: () =>  AremaEditorialView(),
      binding: AremaEditorialBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_AREMAPUTRI,
      page: () => AremaAremaputriView(),
      binding: AremaAremaputriBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_AREMAJUNIOR,
      page: () => AremaAremajuniorView(),
      binding: AremaAremajuniorBinding(),
    ),
    GetPage(
      name: _Paths.AREMA_BERITAFOTO,
      page: () => AremaBeritafotoView(),
      binding: AremaBeritafotoBinding(),
    ),
  ];
}
