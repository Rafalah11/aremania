import 'package:get/get.dart';

import '../modules/Admin_Management_Kursi/bindings/admin_management_kursi_binding.dart';
import '../modules/Admin_Management_Kursi/views/admin_management_kursi_view.dart';
import '../modules/FAQ/bindings/faq_binding.dart';
import '../modules/FAQ/views/faq_view.dart';
import '../modules/Favorite/bindings/favorite_binding.dart';
import '../modules/Favorite/views/favorite_view.dart';
import '../modules/Halaman_AremaDay/bindings/halaman_arema_day_binding.dart';
import '../modules/Halaman_AremaDay/views/halaman_arema_day_view.dart';
import '../modules/Halaman_Aremania/bindings/halaman_aremania_binding.dart';
import '../modules/Halaman_Aremania/views/halaman_aremania_view.dart';
import '../modules/Halaman_Berita_Terbaru/bindings/halaman_berita_terbaru_binding.dart';
import '../modules/Halaman_Berita_Terbaru/views/halaman_berita_terbaru_view.dart';
import '../modules/Halaman_Trending/bindings/halaman_trending_binding.dart';
import '../modules/Halaman_Trending/views/halaman_trending_view.dart';
import '../modules/ReadFavorite/bindings/read_favorite_binding.dart';
import '../modules/ReadFavorite/views/read_favorite_view.dart';
import '../modules/SearchArticlePage/bindings/search_article_page_binding.dart';
import '../modules/SearchArticlePage/views/search_article_page_view.dart';
import '../modules/admin_home/bindings/admin_home_binding.dart';
import '../modules/admin_home/views/admin_home_view.dart';
import '../modules/admin_informasi/bindings/admin_informasiBinding.dart';
import '../modules/admin_informasi/views/adminInformasi_view.dart';
import '../modules/admin_kursi_tiket/bindings/admin_kursi_tiket_binding.dart';
import '../modules/admin_kursi_tiket/views/admin_kursi_tiket_view.dart';
import '../modules/admin_tiket/bindings/admin_tiket_binding.dart';
import '../modules/admin_tiket/views/admin_tiket_view.dart';
import '../modules/admin_transaksi_tiket/bindings/admin_transaksi_tiket_binding.dart';
import '../modules/admin_transaksi_tiket/views/admin_transaksi_tiket_view.dart';
import '../modules/arema_aremajunior/bindings/arema_aremajunior_binding.dart';
import '../modules/arema_aremajunior/views/arema_aremajunior_view.dart';
import '../modules/arema_aremaputri/bindings/arema_aremaputri_binding.dart';
import '../modules/arema_aremaputri/views/arema_aremaputri_view.dart';
import '../modules/arema_beritafoto/bindings/arema_beritafoto_binding.dart';
import '../modules/arema_beritafoto/views/arema_beritafoto_view.dart';
import '../modules/arema_editorial/bindings/arema_editorial_binding.dart';
import '../modules/arema_editorial/views/arema_editorial_view.dart';
import '../modules/aremaday_semua/bindings/aremaday_semua_binding.dart';
import '../modules/aremaday_semua/views/aremaday_semua_view.dart';
import '../modules/aremania_semua/bindings/aremania_semua_binding.dart';
import '../modules/aremania_semua/views/aremania_semua_view.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/connection/views/no_connection_view.dart';
import '../modules/halaman_animasi_awal/bindings/halaman_animasi_awal_binding.dart';
import '../modules/halaman_animasi_awal/views/halaman_animasi_awal_view.dart';
import '../modules/halaman_daftar/bindings/halaman_daftar_binding.dart';
import '../modules/halaman_daftar/views/halaman_daftar_view.dart';
import '../modules/halaman_history_ticket/bindings/halaman_history_ticket_binding.dart';
import '../modules/halaman_history_ticket/views/halaman_history_ticket_view.dart';
import '../modules/halaman_informasi_pribadi/bindings/halaman_informasi_pribadi_binding.dart';
import '../modules/halaman_informasi_pribadi/views/halaman_informasi_pribadi_view.dart';
import '../modules/halaman_login/bindings/halaman_login_binding.dart';
import '../modules/halaman_login/views/halaman_login_view.dart';
import '../modules/halaman_profile/bindings/halaman_profile_binding.dart';
import '../modules/halaman_profile/views/halaman_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kata_sandi/bindings/kata_sandi_binding.dart';
import '../modules/kata_sandi/views/kata_sandi_view.dart';
import '../modules/kategori/bindings/kategori_binding.dart';
import '../modules/kategori/views/kategori_view.dart';
import '../modules/kebijakan_privasi/bindings/kebijakan_privasi_binding.dart';
import '../modules/kebijakan_privasi/views/kebijakan_privasi_view.dart';
import '../modules/laporkan_masalah/bindings/laporkan_masalah_binding.dart';
import '../modules/laporkan_masalah/views/laporkan_masalah_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/management_admin/bindings/management_admin_binding.dart';
import '../modules/management_admin/views/management_admin_view.dart';
import '../modules/ngalam_destinasi/bindings/ngalam_destinasi_binding.dart';
import '../modules/ngalam_destinasi/views/ngalam_destinasi_view.dart';
import '../modules/ngalam_infopenting/bindings/ngalam_infopenting_binding.dart';
import '../modules/ngalam_infopenting/views/ngalam_infopenting_view.dart';
import '../modules/ngalam_kuliner/bindings/ngalam_kuliner_binding.dart';
import '../modules/ngalam_kuliner/views/ngalam_kuliner_view.dart';
import '../modules/ngalam_malangan/bindings/ngalam_malangan_binding.dart';
import '../modules/ngalam_malangan/views/ngalam_malangan_view.dart';
import '../modules/ngalam_read_terbaru/bindings/ngalam_read_terbaru_binding.dart';
import '../modules/ngalam_read_terbaru/views/ngalam_read_terbaru_view.dart';
import '../modules/ngalam_terbaru/bindings/ngalam_terbaru_binding.dart';
import '../modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import '../modules/pusat_bantuan/bindings/pusat_bantuan_binding.dart';
import '../modules/pusat_bantuan/views/pusat_bantuan_view.dart';
import '../modules/read_aremaday/bindings/read_aremaday_binding.dart';
import '../modules/read_aremaday/views/read_aremaday_view.dart';
import '../modules/read_aremania/bindings/read_aremania_binding.dart';
import '../modules/read_aremania/views/read_aremania_view.dart';
import '../modules/read_berita_terbaru/bindings/read_berita_terbaru_binding.dart';
import '../modules/read_berita_terbaru/views/read_berita_terbaru_view.dart';
import '../modules/read_trending/bindings/read_trending_binding.dart';
import '../modules/read_trending/views/read_trending_view.dart';
import '../modules/readdetailartikel/bindings/readdetailartikel_binding.dart';
import '../modules/readdetailartikel/views/readdetailartikel_view.dart';
import '../modules/rincian_ticket/bindings/rincian_ticket_binding.dart';
import '../modules/rincian_ticket/views/rincian_ticket_view.dart';
import '../modules/ticket/bindings/ticket_binding.dart';
import '../modules/ticket/views/ticket_view.dart';
import '../modules/ticket_saya/bindings/ticket_saya_binding.dart';
import '../modules/ticket_saya/views/ticket_saya_view.dart';
import '../modules/transaksi_ticket/bindings/transaksi_ticket_binding.dart';
import '../modules/transaksi_ticket/views/transaksi_ticket_view.dart';
import '../modules/trending_semua/bindings/trending_semua_binding.dart';
import '../modules/trending_semua/views/trending_semua_view.dart';
import '../modules/ubah_kata_sandi/bindings/ubah_kata_sandi_binding.dart';
import '../modules/ubah_kata_sandi/views/ubah_kata_sandi_view.dart';

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
  static const HALAMAN_ANIMASI_AWAL = Routes.HALAMAN_ANIMASI_AWAL;
  static const ADMIN_INFORMASI = Routes.ADMIN_INFORMASI;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
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
      page: () => RincianTicketView(
        docId: '',
      ),
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
      name: _Paths.HALAMAN_ANIMASI_AWAL,
      page: () => HalamanAnimasiAwalView(),
      binding: HalamanAnimasiAwalBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_PROFILE,
      page: () => HalamanProfileView(),
      binding: HalamanProfileBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_INFORMASI_PRIBADI,
      page: () => HalamanInformasiPribadiView(),
      binding: HalamanInformasiPribadiBinding(),
    ),
    GetPage(
      name: _Paths.KATA_SANDI,
      page: () => KataSandiView(),
      binding: KataSandiBinding(),
    ),
    GetPage(
      name: _Paths.UBAH_KATA_SANDI,
      page: () => UbahKataSandiView(),
      binding: UbahKataSandiBinding(),
    ),
    GetPage(
      name: _Paths.KEBIJAKAN_PRIVASI,
      page: () => KebijakanPrivasiView(),
      binding: KebijakanPrivasiBinding(),
    ),
    GetPage(
      name: _Paths.PUSAT_BANTUAN,
      page: () => PusatBantuanView(),
      binding: PusatBantuanBinding(),
    ),
    GetPage(
      name: _Paths.LAPORKAN_MASALAH,
      page: () => LaporkanMasalahView(),
      binding: LaporkanMasalahBinding(),
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_INFORMASI,
      page: () => AdminFormPage(),
      binding: AdminInformasiBinding(),
    ),
    GetPage(
      name: _Paths.READDETAILARTIKEL,
      page: () => ReadDetailArtikelView(),
      binding: ReaddetailartikelBinding(),
    ),
    GetPage(
      name: _Paths.READ_FAVORITE,
      page: () => ReadFavoriteView(),
      binding: ReadFavoriteBinding(),
    ),
    GetPage(
      name: _Paths.TRANSAKSI_TICKET,
      page: () => TransaksiTicketView(
        docId1: '',
      ),
      binding: TransaksiTicketBinding(),
    ),
    GetPage(
      name: _Paths.MANAGEMENT_ADMIN,
      page: () => ManagementAdminView(),
      binding: ManagementAdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => AdminHomeView(),
      binding: AdminHomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_TIKET,
      page: () => AdminTiketView(),
      binding: AdminTiketBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_TRANSAKSI_TIKET,
      page: () => const AdminTransaksiTiketView(),
      binding: AdminTransaksiTiketBinding(),
    ),
    GetPage(
      name: _Paths.TICKET_SAYA,
      page: () => const TicketSayaView(),
      binding: TicketSayaBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_HISTORY_TICKET,
      page: () => const HalamanHistoryTicketView(),
      binding: HalamanHistoryTicketBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_KURSI_TIKET,
      page: () => AdminKursiTiketView(),
      binding: AdminKursiTiketBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_MANAGEMENT_KURSI,
      page: () => AdminManagementKursiView(
        docId1: '',
      ),
      binding: AdminManagementKursiBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => const ConnectionView(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: _Paths.NO_CONNECTION,
      page: () => const NoConnectionView(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_BERITA_TERBARU,
      page: () => HalamanBeritaTerbaruView(),
      binding: HalamanBeritaTerbaruBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_TRENDING,
      page: () => HalamanTrendingView(),
      binding: HalamanTrendingBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_AREMA_DAY,
      page: () => HalamanAremaDayView(),
      binding: HalamanAremaDayBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_AREMANIA,
      page: () => HalamanAremaniaView(),
      binding: HalamanAremaniaBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_ARTICLE_PAGE,
      page: () => SearchArticlePageView(),
      binding: SearchArticlePageBinding(),
    ),
  ];
}
