import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/SearchArticlePage/views/search_article_page_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/kategori/views/kategori_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AremaniaSemuaView(),
    );
  }
}

class AremaniaSemuaView extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<AremaniaSemuaView> {
  // bool _isBookmarked = false; // State untuk melacak status bookmark
  int _selectedIndex = 1; // Untuk melacak tab yang dipilih
  final NgalamTerbaruController _controller =
      Get.put(NgalamTerbaruController());
  Map<String, bool> bookmarkStatus = {};

  // Daftar widget yang sesuai dengan tab yang dipilih

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Aremania',
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
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Get.to(() => SearchArticlePageView());
              },
            ),
          ]),
      body: Column(
        children: [
          // StreamBuilder untuk mendapatkan gambar artikel terbaru
          // Ambil ID Artikel Terbaru
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Informasi')
                .where('kategori', isEqualTo: 'aremania')
                .where('sub_kategori', isEqualTo: 'aremania')
                .orderBy('tanggal_upload', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final latestArticleDoc = snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs[0]
                  : null;

              // Cek apakah ada dokumen
              if (latestArticleDoc == null) {
                return Container(
                  height: 100,
                  child: Center(child: Text('No Articles Available')),
                );
              }

              // Ambil id_artikel terbaru
              String latestId = latestArticleDoc['id_artikel'];

              // Ambil detail artikel berdasarkan id_artikel terbaru
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Informasi')
                    .where('id_artikel',
                        isEqualTo:
                            latestId) // Mengambil detail berdasarkan id_artikel terbaru
                    .snapshots(),
                builder: (context, articleSnapshot) {
                  if (!articleSnapshot.hasData) {
                    return Container(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final articles =
                      articleSnapshot.data!.docs; // Ambil semua dokumen
                  if (articles.isEmpty) {
                    return Container(
                      height: 100,
                      child: Center(child: Text('Tidak ada artikel terbaru')),
                    );
                  }
                  final articleData = articles[0].data()
                      as Map<String, dynamic>; // Data artikel pertama
                  String formattedDate = DateFormat('dd MMMM yyyy')
                      .format(articleData['tanggal_upload'].toDate());
                  String articleId = articles[0].id; // ID artikel pertama

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.NGALAM_READ_TERBARU,
                        arguments: {
                          'id': articleId, // Mengirimkan ID artikel
                          'data': articleData, // Mengirimkan data artikel
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        // Gambar dengan opacity lebih kecil
                        Stack(
                          children: [
                            // Gambar utama
                            articleData['gambar_url'] != null
                                ? Image.network(
                                    articleData['gambar_url'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 220,
                                  )
                                : Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Center(
                                        child: Text('No Image Available')),
                                  ),
                            // Overlay warna hitam dengan opacity
                            Container(
                              height: 220,
                              width: double.infinity,
                              color: Colors.black.withOpacity(
                                  0.5), // Warna hitam dengan transparansi
                            ),
                          ],
                        ),

                        // Overlay teks di atas gambar
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                articleData['judul_artikel'] ?? 'No Title',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.account_circle,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    articleData['nama_upload'] ??
                                        'Unknown Author',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                      fontSize: 16,
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
                },
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Informasi')
                  .where('kategori', isEqualTo: 'aremania')
                  .where('sub_kategori', isEqualTo: 'aremania')
                  .orderBy('tanggal_upload',
                      descending:
                          true) // Urutkan berdasarkan tanggal_upload (terbaru pertama)
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final articles = snapshot.data!.docs;

                if (articles.isEmpty) {
                  return Center(child: Text('No articles available.'));
                }

                // Mengecualikan artikel yang baru diunggah (terbaru pertama)
                // Mengambil artikel kecuali yang pertama (artikel terbaru)
                final filteredArticles = articles
                    .sublist(1); // Menyingkirkan artikel pertama (terbaru)

                return ListView.builder(
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    final articleData =
                        filteredArticles[index].data() as Map<String, dynamic>;
                    String formattedDate = DateFormat('dd MMMM yyyy')
                        .format(articleData['tanggal_upload'].toDate());
                    String articleId = filteredArticles[index].id;

                    return Obx(() {
                      bool isBookmarked =
                          _controller.bookmarkStatus[articleId] ?? false;

                      return InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.NGALAM_READ_TERBARU,
                            arguments: {
                              'id': articleId,
                              'data': articleData,
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.only(left: 17, bottom: 1),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              articleData['gambar_url'] != null
                                  ? Container(
                                      width: 140,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              articleData['gambar_url']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 140,
                                      height: 88,
                                      color: Colors.grey[300],
                                      child: Center(
                                          child: Text('No Image Available')),
                                    ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      articleData['judul_artikel'] ??
                                          'No Title',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.account_circle,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text(articleData['nama_upload'] ??
                                            'Unknown'),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text(formattedDate),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color:
                                      isBookmarked ? Colors.blue : Colors.grey,
                                  size: 24,
                                ),
                                onPressed: () {
                                  var currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  if (currentUser == null) {
                                    Get.toNamed(Routes.HALAMAN_LOGIN);
                                    return;
                                  }
                                  _controller.toggleBookmark(articleId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          )
        ],
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
