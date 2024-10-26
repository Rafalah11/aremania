import 'package:flutter/material.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';

void main() {
  runApp(FavoriteView());
}

class FavoriteView extends StatefulWidget {
  @override
  _FavoriteView createState() => _FavoriteView();
}

class _FavoriteView extends State<FavoriteView> {
  int _selectedIndex = 2;
  List<bool> _isBookmarked = [
    false,
    false,
    false,
    false
  ]; // Status bookmark tiap item

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

  void _toggleBookmark(int index) {
    setState(() {
      _isBookmarked[index] = !_isBookmarked[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logoweare.jpg', height: 60), // Logo Arema
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Berita di Simpan', // Judul utama
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Spasi antara judul dan pencarian
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Pencarian ...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildNewsItem(
                      index: 0,
                      category: "Aremania",
                      title:
                          "Presidium Aremania Buka Lebar Pintu Sekretariat Untuk ...",
                      date: "4 Oktober 2024",
                      imagePath:
                          'assets/gambar1.jpeg'), // Gambar untuk artikel 1
                  _buildNewsItem(
                      index: 1,
                      category: "Aremania",
                      title:
                          "Arema Menjalani 4 Laga Tandang Beruntun, Waktunya ...",
                      date: "9 September 2024",
                      imagePath:
                          'assets/gambar2.jpeg'), // Gambar untuk artikel 2
                  _buildNewsItem(
                      index: 2,
                      category: "Berita Arema",
                      title:
                          "Dalberto Luan Belo Menyala, Jalani Latihan Fisik Arema ...",
                      date: "6 Oktober 2024",
                      imagePath:
                          'assets/gambar3.jpg'), // Gambar untuk artikel 3
                  _buildNewsItem(
                      index: 3,
                      category: "Fokus",
                      title:
                          "5 Fakta Menarik Shulton Fajar, Local Hero yang Dipulangkan ...",
                      date: "10 Oktober 2024",
                      imagePath:
                          'assets/gambar4.jpg'), // Gambar untuk artikel 4
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
    ));
  }

  Widget _buildNewsItem(
      {required int index,
      required String category,
      required String title,
      required String date,
      required String imagePath}) {
    // Tambahkan parameter imagePath
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            child: Image.asset(imagePath, fit: BoxFit.cover), // Gambar berita
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category, // Menampilkan kategori berita
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Text(date),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isBookmarked[index] ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              _toggleBookmark(index); // Mengubah status bookmark
            },
          ),
        ],
      ),
    );
  }
}
