import 'package:flutter/material.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';

void main() {
  runApp(HalamanDaftarView());
}

class HalamanDaftarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarPage(),
    );
  }
}

class DaftarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Membungkus dengan SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginView()),
                    );
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Daftar',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Kata Sandi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Kata Sandi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Action untuk tombol daftar
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
                      'Daftar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text('Atau',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action untuk daftar menggunakan Google
                    },
                    icon: Image.asset(
                      'assets/.png', // Ganti dengan URL icon Google Anda
                      height: 24, // Menyesuaikan ukuran ikon
                    ),
                    label: Text(
                      'Continue with Google',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
