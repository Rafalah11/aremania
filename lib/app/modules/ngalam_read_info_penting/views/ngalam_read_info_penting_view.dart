import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indonesia Sports News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NgalamReadInfoPentingView(),
    );
  }
}

class NgalamReadInfoPentingView extends StatefulWidget {
  @override
  _ReadBeritaTerbaruViewState createState() => _ReadBeritaTerbaruViewState();
}

class _ReadBeritaTerbaruViewState extends State<NgalamReadInfoPentingView> {
  bool isBookmarked = false; // Untuk mengontrol warna bookmark
  int _selectedIndex = 0; // Untuk melacak tab yang dipilih

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Info Penting',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        centerTitle: true, // Teks "Terbaru" di tengah
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.black : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
        ],
        elevation: 1, // Menambahkan bayangan tipis di bawah AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rekam Jejak Malut United Sama Persis Dengan Pencapaian Arema',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Ikon lingkaran di sebelah "oleh Admin"
                      Icon(
                        Icons.circle_rounded,
                        size: 15, // Ukuran ikon lingkaran
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4), // Jarak antara ikon dan teks
                      Text(
                        'oleh Admin',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      // Ikon jam di sebelah waktu terbit
                      Icon(
                        Icons.access_time, // Ikon jam
                        size: 16, // Ukuran ikon jam
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4), // Jarak antara ikon jam dan teks
                      Text(
                        '19 Oktober 2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(
                    color: Colors.grey, // Line panjang di bawah title
                    thickness: 1,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            // Gambar di sini, setelah Divider
            Stack(
              children: [
                Image.asset(
                  'assets/gambar5.jpg', // Ganti dengan path gambar Anda
                  height: 300,
                  width: double.infinity, // Memenuhi lebar layar
                  fit: BoxFit.cover, // Menutupi area secara proporsional
                ),
              ],
            ),

            // Padding untuk konten berikutnya
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tak banyak yang sadar jika rekam jejak Malut United ternyata sama persis dengan pencapaian Arema. Kedua tim bakal diperteukan di Pekan 8 Liga 1 2024-2025, Sabtu (19/10/2024), pukul 15.30 WIB.Pada pertandinan terakhirnya, Malut United mampu meraih kemenangan tandan di markas PSS Sleman 1-0, sesuatu yang gagal dilakukan Arema di Pekan 6 lalu. Arema menelan kekalahan 1-3 dari Super Elang Jawa.Itu merupakan kemenangan kedua Malut United musim ini. Selain dua kemenangan, Laskar Kie Raha juga mencatatkan tiga hasil imbang dan dua kekalahan dalam tujuh pertandingan yang mereka jalani usai promosi dari kasta kedua.Bukan cuma catatan jumlah kemenangan, hasil imbang, dan kekalahannya saja, jumlah gol dan kebobolan Malut United juga sama persis dengan Arema. Anak asuh pelatih Imran Nahumarury tersebut mencetak lima gol dan kebobolan tujuh kali.Sebelum FIFA Matchday Oktober, baik Malut United maupun Arema sama-sama mengoleksi sembilan poin. Bedanya, Arema sedikit ‘lebih beruntung’ dengan menempati peringkat 10, sedangkan Malut United di bawahnya persis.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign:
                        TextAlign.justify, // Mengatur teks menjadi justify
                  ),
                ],
              ),
            ),

            // Konten lain
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inilah Rekam Jejak Malut United Sebelum Bertemu Arema',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16),
                  Image.asset(
                    'assets/gambar9.png', // Ganti dengan path gambar yang Anda gunakan
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Berita Lainnya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  NewsItem(
                    title:
                        'Shin Tae-yong Ungkap Alasan Timnas Indonesia Kalah dari Ukraina',
                    imageUrl:
                        'https://example.com/news1.jpg', // Replace with actual image URL
                  ),
                  NewsItem(
                    title:
                        'Timnas Indonesia U-17 Kalah dari Maroko di Piala Dunia U-17',
                    imageUrl:
                        'https://example.com/news2.jpg', // Replace with actual image URL
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Information',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
        ],
        currentIndex: _selectedIndex, // Mengatur item yang dipilih
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Menangani event ketika item dipilih
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const NewsItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/gambar2.jpeg',
            width: 100,
            height: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
