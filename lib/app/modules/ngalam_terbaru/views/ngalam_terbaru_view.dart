import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/kategori/views/kategori_view.dart';
import 'package:myapp/app/modules/ngalam_destinasi/views/ngalam_destinasi_view.dart';
import 'package:myapp/app/modules/ngalam_infopenting/views/ngalam_infopenting_view.dart';
import 'package:myapp/app/modules/ngalam_kuliner/views/ngalam_kuliner_view.dart';
import 'package:myapp/app/modules/ngalam_malangan/views/ngalam_malangan_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class NgalamTerbaruView extends StatefulWidget {
  @override
  _NgalamTerbaruViewState createState() => _NgalamTerbaruViewState();
}

class _NgalamTerbaruViewState extends State<NgalamTerbaruView> {
  // bool _isBookmarked = false;
  Map<String, bool> bookmarkStatus = {};
  int _selectedIndex = 1;
  int _selectedMenuIndex = 0;
  final NgalamTerbaruController _controller =
      Get.put(NgalamTerbaruController());

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

  // Tambahkan ini untuk memastikan sinkronisasi data setiap kali kembali ke halaman ini
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.reloadBookmarkStatus(); // Reload status bookmark
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
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
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
                .where('kategori', isEqualTo: 'ngalam')
                .where('sub_kategori', isEqualTo: 'terbaru')
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
          // Menu horizontal yang dapat digulir
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
                  .where('sub_kategori', isEqualTo: 'terbaru')
                  .snapshots(includeMetadataChanges: true),
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

                    // Status bookmark untuk ikon
                    bool isBookmarked = articleData['isBookmarked'] ?? false;

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
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked ? Colors.blue : Colors.grey,
                              size: 24,
                            ),
                            onPressed: () {
                              // Panggil toggleBookmark untuk mengubah status bookmark artikel
                              _controller.toggleBookmark(articles[index].id);
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
                                child:
                                    Center(child: Text('No Image Available')),
                              ),
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
          )
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
