import 'package:flutter/material.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/halaman_daftar/views/halaman_daftar_view.dart';
import 'package:myapp/app/modules/halaman_login/views/halaman_login_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';

void main() {
  runApp(LoginView());
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logoweare.jpg', // Ganti dengan URL logo Anda
                    height: 60,
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanLoginView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Masuk',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanDaftarView()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Atau',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      '', // Ganti dengan URL icon Google Anda
                      height: 24,
                    ),
                    label: Text(
                      'Menggunakan Google',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Belum memiliki akun?',
                          style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () {},
                        child: Text('Daftar',
                            style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
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
}
