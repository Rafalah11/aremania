import 'package:get/get.dart';

import '../modules/Favorite/bindings/favorite_binding.dart';
import '../modules/Favorite/views/favorite_view.dart';
import '../modules/News_page/bindings/news_page_binding.dart';
import '../modules/News_page/views/news_page_view.dart';
import '../modules/abc/bindings/abc_binding.dart';
import '../modules/abc/views/abc_view.dart';
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
import '../modules/halaman_daftar/bindings/halaman_daftar_binding.dart';
import '../modules/halaman_daftar/views/halaman_daftar_view.dart';
import '../modules/halaman_login/bindings/halaman_login_binding.dart';
import '../modules/halaman_login/views/halaman_login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kategori/bindings/kategori_binding.dart';
import '../modules/kategori/views/kategori_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/ngalam_destinasi/bindings/ngalam_destinasi_binding.dart';
import '../modules/ngalam_destinasi/views/ngalam_destinasi_view.dart';
import '../modules/ngalam_infopenting/bindings/ngalam_infopenting_binding.dart';
import '../modules/ngalam_infopenting/views/ngalam_infopenting_view.dart';
import '../modules/ngalam_kuliner/bindings/ngalam_kuliner_binding.dart';
import '../modules/ngalam_kuliner/views/ngalam_kuliner_view.dart';
import '../modules/ngalam_malangan/bindings/ngalam_malangan_binding.dart';
import '../modules/ngalam_malangan/views/ngalam_malangan_view.dart';
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
import '../modules/rincian_ticket/bindings/rincian_ticket_binding.dart';
import '../modules/rincian_ticket/views/rincian_ticket_view.dart';
import '../modules/ticket/bindings/ticket_binding.dart';
import '../modules/ticket/views/ticket_view.dart';
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
  static const NGALAM_KULINER = Routes.NGALAM_KULINER;
  static const NGALAM_DESTINASI = Routes.NGALAM_DESTINASI;
  static const NGALAM_MALANGAN = Routes.NGALAM_MALANGAN;
  static const NGALAM_INFOPENTING = Routes.NGALAM_INFOPENTING;
  static const FAVORITE = Routes.FAVORITE;
  static const TICKET = Routes.TICKET;
  static const RINCIAN_TICKET = Routes.RINCIAN_TICKET;
  static const KATEGORI = Routes.KATEGORI;
  static const LOGIN = Routes.LOGIN;
  static const HALAMAN_LOGIN = Routes.HALAMAN_LOGIN;
  static const HALAMAN_DAFTAR = Routes.HALAMAN_DAFTAR;

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
      page: () => AremaEditorialView(),
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
    GetPage(
      name: _Paths.NGALAM_KULINER,
      page: () => NgalamKulinerView(),
      binding: NgalamKulinerBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_DESTINASI,
      page: () => NgalamDestinasiView(),
      binding: NgalamDestinasiBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_MALANGAN,
      page: () => NgalamMalanganView(),
      binding: NgalamMalanganBinding(),
    ),
    GetPage(
      name: _Paths.NGALAM_INFOPENTING,
      page: () => NgalamInfopentingView(),
      binding: NgalamInfopentingBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () => FavoriteView(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: _Paths.TICKET,
      page: () => Ticket_View(),
      binding: TicketBinding(),
    ),
    GetPage(
      name: _Paths.RINCIAN_TICKET,
      page: () => RincianTicketView(),
      binding: RincianTicketBinding(),
    ),
    GetPage(
      name: _Paths.KATEGORI,
      page: () => KategoriView(),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_LOGIN,
      page: () => HalamanLoginView(),
      binding: HalamanLoginBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_DAFTAR,
      page: () => HalamanDaftarView(),
      binding: HalamanDaftarBinding(),
    ),
    GetPage(
      name: _Paths.ABC,
      page: () => const AbcView(),
      binding: AbcBinding(),
    ),
  ];
}
