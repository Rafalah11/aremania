import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/kategori/views/kategori_view.dart';
import 'package:myapp/app/modules/ngalam_destinasi/views/ngalam_destinasi_view.dart';
import 'package:myapp/app/modules/ngalam_infopenting/views/ngalam_infopenting_view.dart';
import 'package:myapp/app/modules/ngalam_kuliner/views/ngalam_kuliner_view.dart';
import 'package:myapp/app/modules/ngalam_malangan/views/ngalam_malangan_view.dart';
import 'package:myapp/app/modules/ngalam_read_terbaru/views/ngalam_read_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NgalamTerbaruView(),
    );
  }
}

class NgalamTerbaruView extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NgalamTerbaruView> {
  bool _isBookmarked = false;
  int _selectedIndex = 1;
  int _selectedMenuIndex = 0; // Set to Arema Junior by default

  final List<String> _menuTitles = [
    'Terbaru',
    'Destinasi',
    'Malangan',
    'Kuliner',
    'Info Penting'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah indeks terpilih
    });

    // Navigasi berdasarkan indeks
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      // Indeks 1 adalah untuk ikon "Explore"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NgalamTerbaruView()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoriteView()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Ticket_View()),
      );
    }
  }

  void _onMenuTapped(int index) {
    // When tapping on any menu item other than Arema Junior, reset the selectedMenuIndex
    if (index != 3) {
      _selectedMenuIndex = 1; // Reset to Arema Junior as the only selected menu
    } else {
      _selectedMenuIndex = index; // Set to Arema Junior
    }

    // Navigate to the appropriate page
    if (index == 0) {
      Get.to(() => NgalamTerbaruView());
    } else if (index == 1) {
      Get.to(() => NgalamDestinasiView());
    } else if (index == 2) {
      Get.to(() => NgalamMalanganView());
    } else if (index == 3) {
      Get.to(() => NgalamKulinerView());
    } else if (index == 4) {
      Get.to(() => NgalamInfopentingView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Ngalam',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      KategoriView()), // Ganti dengan nama halaman yang sesuai
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: IconButton(
              icon: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: _isBookmarked ? Colors.black : Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _isBookmarked = !_isBookmarked;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Aksi ketika ikon pencarian diklik
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFeaturedNewsCard(),
            // Horizontal scrollable menu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_menuTitles.length, (index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15),
                      child: InkWell(
                        onTap: () => _onMenuTapped(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                          decoration: BoxDecoration(
                            // Background color for Arema Junior menu
                            color: _selectedMenuIndex == 0 && index == 0
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            _menuTitles[index],
                            style: TextStyle(
                              color: _selectedMenuIndex == 3 && index == 3
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ));
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Mbois, Pelatih Arema Terpilih Sebagai Coach Of The Week Pekan 7',
                    subtitle: 'Berita Arema • 2 jam yang lalu',
                    imagePath: 'assets/gambar2.jpeg',
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        '5 Fakta Menarik Thales Lira, Pemain Termahal yang Didatangkan Arema Musim Ini',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar3.jpg',
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar5.jpg',
                  ),
                  SizedBox(height: 16),
                  _buildFullWidthNewsItem(
                    title:
                        'Arema Kalahkan Persib Bandung, Inilah Statistik dan Skor Akhir',
                    subtitle: 'Berita Arema • 1 jam yang lalu',
                    imagePath: 'assets/gambar4.jpg',
                    context: context,
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar6.jpeg',
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar7.jpeg',
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar8.jpeg',
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar9.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number), // Material Icons untuk tiket
            label: 'Ticket',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildFeaturedNewsCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to the Arema Read Arema Junior page
        Get.to(() => NgalamReadTerbaruView());
      },
      child: Stack(
        children: [
          // Background image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Opacity(
              opacity: 0.8, // Atur opacity ke 0.8 untuk efek memudar 80%
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/gambar1.jpeg'), // Ganti dengan gambar yang sesuai
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Overlay text
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terbaru Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Intip Lawan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '14 detik yang lalu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallNewsListItem({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Arema Read Arema Junior page
        Get.to(() => NgalamReadTerbaruView());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthNewsItem({
    required String title,
    required String subtitle,
    required String imagePath,
    required BuildContext context, // Menambahkan parameter context
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            // Membungkus Image.asset dengan GestureDetector
            onTap: () {
              // Aksi ketika gambar diklik
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NgalamReadTerbaruView()), // Ganti dengan halaman yang diinginkan
              );
            },
            child: Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.circle, color: Colors.grey, size: 10),
                    SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
