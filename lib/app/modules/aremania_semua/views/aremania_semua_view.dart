import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
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
              // Aksi ketika ikon pencarian diklik
            },
          ),
        ],
      ),
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

                  final articleData = articleSnapshot.data!.docs.isNotEmpty
                      ? articleSnapshot.data!.docs[0]
                      : null;

                  return GestureDetector(
                    onTap: () {
                      // Kirim seluruh data artikel ke halaman detail
                      Get.toNamed(
                        Routes.NGALAM_READ_TERBARU,
                        arguments: articleData
                            ?.data(), // Mengirim seluruh data dokumen
                      );
                    },
                    child: Container(
                      height: 200, // Set tinggi untuk gambar
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            0), // Pastikan tidak ada radius
                        color: Colors
                            .transparent, // Pastikan latar belakang transparan
                      ),
                      child: Stack(
                        children: [
                          // Gambar dengan transparansi
                          Opacity(
                            opacity: 0.8,
                            child: articleData != null &&
                                    articleData['gambar_url'] != null
                                ? ClipRect(
                                    child: Image.network(
                                      articleData['gambar_url'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                        child: Text('No Image Available')),
                                  ),
                          ),
                          // Overlay dengan teks di atas gambar
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: const Color.fromARGB(207, 0, 0, 0),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articleData?['judul_artikel'] ?? 'No Title',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        articleData?['nama_upload'] ??
                                            'Unknown Author',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      SizedBox(width: 15),
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        articleData?['tanggal_upload'] != null
                                            ? DateFormat('dd-MM-yyyy').format(
                                                articleData!['tanggal_upload']
                                                    .toDate())
                                            : 'No Date',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    // Ambil data artikel dari snapshot
                    final articleData =
                        articles[index].data() as Map<String, dynamic>;

                    // Mengonversi timestamp ke tanggal
                    String formattedDate = DateFormat('yyyy-MM-dd')
                        .format(articleData['tanggal_upload'].toDate());

                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              articleData['judul_artikel'] ?? 'No Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Obx(() => Icon(
                                  _controller.bookmarkStatus[
                                              articles[index].id] ==
                                          true
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: _controller.bookmarkStatus[
                                              articles[index].id] ==
                                          true
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 24,
                                )),
                            onPressed: () {
                              // Pastikan untuk memanggil toggleBookmark dengan artikel ID yang benar
                              _controller.toggleBookmark(articles[index]
                                  .id); // Pass articleId (String)
                            },
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.account_circle,
                              size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(articleData['nama_upload'] ?? 'Unknown'),
                          SizedBox(width: 10),
                          Icon(Icons.access_time, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(formattedDate),
                        ],
                      ),
                      leading: articleData['gambar_url'] != null
                          ? SizedBox(
                              width: 115,
                              height: 150,
                              child: Image.network(
                                articleData['gambar_url'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : SizedBox(
                              width: 115,
                              height: 150,
                              child: Container(
                                  color: Colors.grey[300],
                                  child: Center(
                                      child: Text('No Image Available'))),
                            ),
                      onTap: () {
                        // Kirim seluruh data artikel ke halaman detail
                        Get.toNamed(
                          Routes.NGALAM_READ_TERBARU,
                          arguments: articles[index]
                              .data(), // Mengirim seluruh data dokumen
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
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
