import 'package:flutter/material.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedMenuIndex = 0;

  // Menu Titles
  final List<String> _menuTitles = [
    'Semua',
    'Berita Terbaru',
    'Trending',
    'Arema Day',
    'Aremania/nita'
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

    // Logika navigasi sesuai dengan indeks
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Replace with your page
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Replace with your page
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Replace with your page
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Replace with your page
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Replace with your page
        );
        break;
      default:
        break;
    }
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
              SizedBox(width: 10),
              Text('', style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.person,
                  color: Colors.grey), // Ganti dengan icon orang
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Welcome!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.notifications,
                          color: Colors.grey), // Icon lonceng di kanan
                      onPressed: () {},
                    ),
                  ],
                ),
                Text("Hari ini, 13 Okt 2024"),
                SizedBox(height: 20),

                // Search Box (Pencarian)
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Pencarian...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  child: Row(
                    children: List.generate(_menuTitles.length, (index) {
                      bool isSelected = _selectedMenuIndex ==
                          index; // Check if the tab is selected
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => _onMenuTapped(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (index == 0
                                        ? Color.fromARGB(255, 12, 0, 247)
                                        : Colors.grey[300])
                                    : Colors.grey[
                                        300], // Gray background for other tabs
                                borderRadius: BorderRadius.circular(
                                    8), // Rounded corners for individual tabs
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20), // Padding for tabs
                              child: Text(
                                _menuTitles[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors
                                          .black, // White for selected tab text
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Add space between items
                        ],
                      );
                    }),
                  ),
                ),

                SizedBox(height: 20),

                // Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Berita Terbaru",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Berita Terbaru Cards
                Container(
                  height: 250, // Sesuaikan tinggi sesuai kebutuhan
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal, // Set scrolling horizontal
                    children: [
                      // Card pertama
                      Container(
                        width: 200, // Set width untuk setiap card
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/gambar1.jpeg',
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: double.infinity),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rekam Jejak Malut United, Sama Persis Dengan Pencapaian Arema",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye, size: 12),
                                        SizedBox(width: 5),
                                        Text("14 detik yang lalu"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Jarak antar Card

                      // Card kedua
                      Container(
                        width: 200,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/gambar2.jpeg',
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: double.infinity),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jadwal Arema di Liga 1 2024–2025 Pekan 8",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye, size: 12),
                                        SizedBox(width: 5),
                                        Text("2 jam yang lalu"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset('assets/gambar3.jpg',
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: double.infinity),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Jadwal Arema di Liga 1 2024–2025 Pekan 8",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.remove_red_eye, size: 12),
                                        SizedBox(width: 5),
                                        Text("2 jam yang lalu"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                // Tabs dan konten Trending
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Trending",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Trending Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar4.jpg',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Arema FC Perkuat Lini Serang, Rekrut Striker Asing Jelang Putaran ...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Berita Arema • Senin, 4 Jun 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar5.jpg',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "5 Fakta Menarik Wiliam Marcilio, Mastro Arema Dari Rio de Janeiro",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Focus • Senin, 4 Jun 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Arema Day",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Berita Terbaru Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar7.jpeg',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jadwal Arema di Liga 1 2024-2025 Pekan 8",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Arema Day • Rabu, 9 Okt 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar8.jpeg',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hasil Liga 1 2024-2025 PSIS Semarang vs Arema, 26 September ...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Arema Day • Rabu, 9 Okt 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aremania / nita",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Berita Terbaru Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar9.png',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Presidium Aremania Buka Lebar Pintu Sekretariat Untuk ...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Aremania • Kamis, 6 Jun 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/gambar10.jpg',
                                fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hadiri Doa Bersama 2 Tahun Tragedi Kanjuruhan, Begini ...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 12),
                                      SizedBox(width: 5),
                                      Text("Aremania • Kamis, 6 Jun 24"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              icon:
                  Icon(Icons.confirmation_number), // Material Icons untuk tiket
              label: 'Ticket',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Fungsi untuk membuat Tab Button
  Widget _buildTabButton(String tabTitle) {
    return GestureDetector(
      onTap: () => _selectedIndex,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color:
              _selectedMenuIndex == tabTitle ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Text(
          tabTitle,
          style: TextStyle(
            color: _selectedMenuIndex == tabTitle
                ? Colors.white
                : Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
