import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk format tanggal
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/controllers/ngalam_terbaru_controller.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/readdetailartikel/controllers/readdetailartikel_controller.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class FavoriteView extends StatefulWidget {
  @override
  _FavoriteView createState() => _FavoriteView();
}

class _FavoriteView extends State<FavoriteView> {
  int _selectedIndex = 2;
  List<bool> _isBookmarked = []; // Status bookmark tiap item
  List<DocumentSnapshot> _newsItems = []; // Menyimpan dokumen berita
  List<DocumentSnapshot> _filteredNewsItems =
      []; // Menyimpan hasil filter pencarian
  TextEditingController _searchController =
      TextEditingController(); // Controller pencarian
  final NgalamTerbaruController _ngalamTerbaruController = Get.find();
  final ReaddetailartikelController _readArtikelController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchBookmarks(); // Panggil fungsi untuk mengambil data bookmarks
    _searchController
        .addListener(_filterNews); // Menambahkan listener untuk pencarian
  }

  // Future<void> _fetchBookmarks() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('bookmarks')
  //         .orderBy('tanggal_upload', descending: true)
  //         .get();

  //     setState(() {
  //       _newsItems = snapshot.docs;
  //       _filteredNewsItems = List.from(_newsItems);
  //     });
  //   } catch (e) {
  //     print("Error fetching bookmarks: $e");
  //   }
  // }
  Future<void> _fetchBookmarks() async {
    try {
      // Ambil UID pengguna yang sedang login
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Jika pengguna belum login, arahkan ke halaman login
        Get.toNamed(Routes.LOGIN);
        return;
      }

      // Ambil data bookmark berdasarkan UID pengguna
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(currentUser.uid) // Gunakan UID pengguna
          .collection('userBookmarks')
          .orderBy('tanggal_upload', descending: true)
          .get();

      setState(() {
        _newsItems = snapshot.docs;
        _filteredNewsItems = List.from(_newsItems);
      });

      // Update bookmark status di kedua controller
      for (var doc in snapshot.docs) {
        String docId = doc.id;
        // Update bookmarkStatus di kedua controller
        _ngalamTerbaruController.bookmarkStatus[docId] = true;
        _readArtikelController.bookmarkStatus[docId] = true;
      }
    } catch (e) {
      print("Error fetching bookmarks: $e");
    }
  }

  // Fungsi untuk memfilter berita berdasarkan pencarian
  void _filterNews() {
    String query =
        _searchController.text.toLowerCase(); // Ambil query pencarian
    if (query.isEmpty) {
      // Jika pencarian kosong, tampilkan semua artikel
      setState(() {
        _filteredNewsItems = List.from(_newsItems);
      });
    } else {
      // Jika ada query pencarian, filter artikel berdasarkan judul
      setState(() {
        _filteredNewsItems = _newsItems.where((newsItem) {
          String title = newsItem['judul_artikel'] ?? '';
          return title
              .toLowerCase()
              .contains(query); // Pencocokan kata kunci di judul artikel
        }).toList();
      });
    }
  }

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

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan bookmark
  Future<void> _showDeleteDialog(int index, String docId) async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Bookmark"),
          content: Text(
              "Apakah Anda yakin ingin menghapus artikel ini dari favorit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Tidak jadi menghapus
              },
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Hapus artikel
              },
              child: Text("Iya"),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _toggleBookmark(index, docId);
    }
  }

  void _toggleBookmark(int index, String docId) async {
    var newsItem = _filteredNewsItems[index];
    String docId = newsItem.id;

    // Remove from Firestore
    try {
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(docId)
          .delete();

      // Remove from local list
      setState(() {
        _filteredNewsItems.removeAt(index);
      });

      // Update NgalamTerbaruController's bookmark status
      _ngalamTerbaruController.bookmarkStatus[docId] = false;
    } catch (e) {
      print("Error deleting bookmark: $e");
    }
  }
  // void _toggleBookmark(int index) async {
  //   var newsItem = _filteredNewsItems[index];
  //   String docId = newsItem.id;

  //   try {
  //     // Menambahkan atau menghapus bookmark di Firestore
  //     if (_ngalamTerbaruController.bookmarkStatus[docId] == true) {
  //       await FirebaseFirestore.instance
  //           .collection('bookmarks')
  //           .doc(docId)
  //           .delete();
  //       _ngalamTerbaruController.bookmarkStatus[docId] =
  //           false; // Set status bookmark ke false
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection('bookmarks')
  //           .doc(docId)
  //           .set(newsItem.data() as Map<String, dynamic>);
  //       _ngalamTerbaruController.bookmarkStatus[docId] =
  //           true; // Set status bookmark ke true
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     print("Error updating bookmark: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              controller: _searchController,
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
              child: ListView.builder(
                itemCount: _filteredNewsItems
                    .length, // Menggunakan jumlah item yang sudah difilter
                itemBuilder: (context, index) {
                  return _buildNewsItem(index, _filteredNewsItems[index]);
                },
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
    );
  }

  Widget _buildNewsItem(int index, dynamic articleSnapshot) {
    var newsItem = _filteredNewsItems[index];
    String category = newsItem['kategori'] ?? 'No Category';
    String title = newsItem['judul_artikel'] ?? 'No Title';

    Timestamp timestamp = newsItem['tanggal_upload'];
    String date = DateFormat('dd MMMM yyyy').format(timestamp.toDate());

    String imagePath =
        newsItem['gambar_url'] ?? 'https://example.com/default-image.png';

    String docId = newsItem.id;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.READ_FAVORITE, arguments: newsItem.data());
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              child: Image.network(imagePath, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category,
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 5),
                    Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 10),
                    Text(date),
                  ],
                ),
              ),
            ),
            Obx(() {
              bool isBookmarked = _ngalamTerbaruController
                      .bookmarkStatus[docId] ??
                  false ||
                      (_readArtikelController.bookmarkStatus[docId] ?? false);

              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  // Panggil dialog konfirmasi sebelum melakukan toggle
                  _showDeleteDialog(
                      index, docId); // Tampilkan dialog penghapusan
                },
              );
            }),
            // Obx(() {
            //   bool isBookmarked =
            //       _ngalamTerbaruController.bookmarkStatus[docId] ?? false;
            //   return IconButton(
            //     icon: Icon(
            //         isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            //         color: isBookmarked ? Colors.blue : Colors.grey),
            //     onPressed: () {
            //       _showDeleteDialog(
            //           index, docId); // Menampilkan dialog konfirmasi
            //     },
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
