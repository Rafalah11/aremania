import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class PusatBantuanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pusat Bantuan',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FAQScreen(),
    );
  }
}

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("Pusat Bantuan"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ExpansionTile(
            title: Text("1. Bagaimana cara membuat atau mengelola akun saya?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Untuk membuat akun baru, pilih opsi "Daftar" di halaman masuk. Isi informasi yang diminta, seperti email dan kata sandi, lalu verifikasi akun Anda melalui email. Anda juga dapat mengelola profil dan informasi akun di menu pengaturan setelah login.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("2. Bagaimana cara mengatur metode pembayaran?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Anda dapat menambahkan atau mengubah metode pembayaran di menu "Pengaturan Pembayaran". Pilih metode pembayaran yang tersedia, seperti kartu kredit atau transfer bank, lalu ikuti petunjuk untuk menambahkannya ke akun Anda.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("3. Mengapa saya tidak menerima notifikasi?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Pastikan notifikasi diaktifkan pada menu Pengaturan > Notifikasi dalam aplikasi dan di pengaturan perangkat Anda. Jika masalah berlanjut, coba keluar dari aplikasi dan masuk kembali.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("4. Bagaimana cara menghapus akun saya?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Untuk menghapus akun, buka Pengaturan > Akun, lalu pilih opsi "Hapus Akun". Harap dicatat bahwa penghapusan akun bersifat permanen dan semua data Anda akan dihapus.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("5. Apakah informasi pribadi saya aman?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Kami berkomitmen untuk melindungi privasi Anda. Data pribadi Anda disimpan dengan aman dan digunakan sesuai dengan kebijakan privasi kami. Kami tidak akan membagikan data Anda kepada pihak ketiga tanpa izin.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("6. Bagaimana cara mengubah bahasa di aplikasi?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Anda dapat mengubah bahasa aplikasi dengan membuka Pengaturan > Bahasa. Pilih bahasa yang Anda inginkan dari daftar bahasa yang tersedia.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("7. Bagaimana cara mengatasi masalah pembayaran?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Jika Anda mengalami masalah saat melakukan pembayaran, periksa koneksi internet dan metode pembayaran Anda. Anda juga bisa mencoba metode pembayaran lainnya atau menghubungi tim dukungan kami untuk bantuan lebih lanjut.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("8. Bagaimana cara mengatur preferensi notifikasi?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Anda dapat mengatur preferensi notifikasi di Pengaturan > Notifikasi. Di sini Anda dapat memilih jenis notifikasi yang ingin diaktifkan, seperti pesan, pembaruan aplikasi, atau penawaran khusus.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title:
                Text("9. Bagaimana cara melaporkan bug atau masalah teknis?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Untuk melaporkan masalah, buka Pengaturan > Bantuan > Laporkan Masalah. Sertakan deskripsi masalah serta tangkapan layar jika memungkinkan untuk membantu tim kami memperbaiki masalah tersebut.
                  </p>""",
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("10. Bagaimana cara menghubungi dukungan pelanggan?"),
            children: [
              ListTile(
                title: HtmlWidget(
                  """<p style="text-align: justify;">
                    Jika Anda membutuhkan bantuan lebih lanjut, Anda dapat menghubungi tim dukungan kami melalui menu "Kontak Kami" di dalam aplikasi atau mengirim email ke support@wearemania.com.
                  </p>""",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
