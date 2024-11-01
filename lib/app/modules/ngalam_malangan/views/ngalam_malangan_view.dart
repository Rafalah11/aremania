import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/kategori/views/kategori_view.dart';
import 'package:myapp/app/modules/ngalam_destinasi/views/ngalam_destinasi_view.dart';
import 'package:myapp/app/modules/ngalam_infopenting/views/ngalam_infopenting_view.dart';
import 'package:myapp/app/modules/ngalam_kuliner/views/ngalam_kuliner_view.dart';
import 'package:myapp/app/modules/ngalam_read_terbaru/views/ngalam_read_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NgalamMalanganView(),
    );
  }
}

class NgalamMalanganView extends StatefulWidget {
  @override
  _NgalamMalanganViewState createState() => _NgalamMalanganViewState();
}

class _NgalamMalanganViewState extends State<NgalamMalanganView> {
  bool _isBookmarked = false;
  int _selectedIndex = 1;
  int _selectedMenuIndex = 0;

  final List<String> _menuTitles = [
    'Terbaru',
    'Destinasi',
    'Malangan',
    'Kuliner',
    'Info Penting'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
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
    setState(() {
      _selectedMenuIndex = index;
    });

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

  Widget _buildFeaturedNewsCard() {
    return GestureDetector(
      onTap: () {
        Get.to(() => NgalamReadTerbaruView());
      },
      child: Stack(
        children: [],
      ),
    );
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
              MaterialPageRoute(builder: (context) => KategoriView()),
            );
          },
        ),
        actions: [
          IconButton(
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
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFeaturedNewsCard(),
          // Horizontal scrollable menu
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_menuTitles.length, (index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                  child: InkWell(
                    onTap: () => _onMenuTapped(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: _selectedMenuIndex == index
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _menuTitles[index],
                        style: TextStyle(
                          color: _selectedMenuIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Informasi')
                  .where('kategori', isEqualTo: 'ngalam')
                  .where('sub_kategori', isEqualTo: 'malangan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final articles = snapshot.data!.docs;
                if (articles.isEmpty) {
                  return Center(child: Text('No articles available.'));
                }

                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(
                      title: Text(article['judul_artikel']),
                      subtitle: Text((article['tanggal_upload'] as Timestamp)
                          .toDate()
                          .toString()),
                      leading: article['gambar_url'] != null
                          ? Image.network(article['gambar_url'],
                              width: 50, height: 50)
                          : null,
                      onTap: () {
                        Get.to(() => NgalamReadTerbaruView());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
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
}
