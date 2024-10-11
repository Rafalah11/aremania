import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _isBookmarked = false; // State untuk melacak status bookmark
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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Berita Terbaru',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(Icons.arrow_back_ios, color: Colors.black),
        actions: [
          // Menggunakan Padding untuk menggeser ikon bookmark ke kanan
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0), // Mengatur padding kiri untuk ikon bookmark
            child: IconButton(
              icon: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: _isBookmarked
                    ? Colors.black
                    : Colors
                        .black54, // Mengubah warna berdasarkan status bookmark
              ),
              onPressed: () {
                setState(() {
                  _isBookmarked = !_isBookmarked; // Toggle status bookmark
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
            // Featured news at the top, tanpa padding
            _buildFeaturedNewsCard(),
            // Padding untuk list berita lainnya
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Mbois, Pelatih Arema Terpilih Sebagai Coach Of The Week Pekan 7',
                    subtitle: 'Berita Arema • 2 jam yang lalu',
                    imagePath: 'assets/gambar2.jpeg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        '5 Fakta Menarik Thales Lira, Pemain Termahal yang Didatangkan Arema Musim Ini',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar3.jpg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar4.jpg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  // Satu artikel terakhir dengan gambar yang memenuhi lebar penuh
                  _buildFullWidthNewsItem(
                    title:
                        'Arema Kalahkan Persib Bandung, Inilah Statistik dan Skor Akhir',
                    subtitle: 'Berita Arema • 1 jam yang lalu',
                    imagePath: 'assets/gambar5.jpg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar6.jpeg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar7.jpeg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar8.jpeg', // Replace with your image
                  ),
                  SizedBox(height: 16),
                  _buildSmallNewsListItem(
                    title:
                        'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                    subtitle: 'Berita Arema • 3 jam yang lalu',
                    imagePath: 'assets/gambar9.png', // Replace with your image
                  ),
                  SizedBox(height: 20),
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

  // Featured news card tanpa padding
  Widget _buildFeaturedNewsCard() {
    return Stack(
      children: [
        // Background image
        Container(
          width: double.infinity, // Memastikan gambar memenuhi lebar penuh
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Opacity(
              opacity: 0.8, // Agar sudut tetap melengkung
              child: Image.asset(
                'assets/gambar1.jpeg', // Ganti dengan gambar yang sesuai
                fit: BoxFit.cover, // Memastikan gambar memenuhi container
                width: double.infinity, // Memenuhi lebar penuh
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
                'Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
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
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '14 detik yang lalu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build small news list item with smaller image and details
  Widget _buildSmallNewsListItem({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 120, // Lebar gambar yang lebih kecil
            height: 80,
            fit: BoxFit.cover,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14),
                  SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build the news list item with full-width image and text overlay
  Widget _buildFullWidthNewsItem({
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Margin bawah antar item
      child: Stack(
        children: [
          // Gambar yang memenuhi lebar penuh
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: double.infinity, // Gambar memenuhi lebar layar
              height: 200, // Atur tinggi gambar sesuai keinginan
              fit: BoxFit.cover, // Gambar menyesuaikan ukuran container
            ),
          ),
          // Overlay teks di atas gambar
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9), // Warna subtitle
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
}
