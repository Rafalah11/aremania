import 'package:flutter/material.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/rincian_ticket/views/rincian_ticket_view.dart';

void main() {
  runApp(Ticket_View());
}

class Ticket_View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MatchScheduleScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),
    );
  }
}

class MatchScheduleScreen extends StatefulWidget {
  @override
  _MatchScheduleScreenState createState() => _MatchScheduleScreenState();
}

class _MatchScheduleScreenState extends State<MatchScheduleScreen> {
  int _selectedIndex = 3;

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
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.person, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian header dengan logo
              Container(
                color: Colors.blue.shade800,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/gambar1.jpeg', // Sesuaikan dengan path gambar tim
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              // Jadwal pertandingan
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cek Jadwal Pertandingan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Jangan Lewatkan Pertandingan Terbesar Musim Ini!",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Konten di bawah jadwal pertandingan (seperti gambar tim dengan waktu pertandingan)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    matchCard('assets/gambar10.jpg'), // Kartu pertama
                    SizedBox(height: 16),
                    matchCard('assets/gambar11.jpg'), // Kartu kedua
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

  // Widget untuk kartu pertandingan
  Widget matchCard(String imagePath) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RincianTicketView(),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath, // Menggunakan parameter imagePath
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "19.00 WIB  •  10 Oktober 2024",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Stadion Glora Bung Karno"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  }
