import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  List<DocumentSnapshot> _newsItems = [];
  List<DocumentSnapshot> _filteredNewsItems = [];
  TextEditingController _searchController = TextEditingController();
  final NgalamTerbaruController _ngalamTerbaruController = Get.find();
  final ReaddetailartikelController _readArtikelController = Get.find();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _checkUserLogin();
    _searchController.addListener(_filterNews);
  }

  // Cek apakah pengguna sudah login
  void _checkUserLogin() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _fetchBookmarks();
    }
  }

  Future<void> _fetchBookmarks() async {
    try {
      if (currentUser == null) {
        print("User belum login");
        return;
      }

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(currentUser!.uid)
          .collection('userBookmarks')
          .orderBy('tanggal_upload', descending: true)
          .get();

      setState(() {
        _newsItems = snapshot.docs;
        _filteredNewsItems = List.from(_newsItems);
      });

      for (var doc in snapshot.docs) {
        String docId = doc.id;
        _ngalamTerbaruController.bookmarkStatus[docId] = true;
        _readArtikelController.bookmarkStatus[docId] = true;
      }

      print("Bookmarks berhasil diambil");
    } catch (e) {
      print("Error fetching bookmarks: $e");
    }
  }

  void _filterNews() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredNewsItems = List.from(_newsItems);
      });
    } else {
      setState(() {
        _filteredNewsItems = _newsItems.where((newsItem) {
          String title = newsItem['judul_artikel'] ?? '';
          return title.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NgalamTerbaruView()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FavoriteView()));
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Ticket_View()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus ikon back
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logoweare.jpg', height: 60),
          ],
        ),
        centerTitle: false,
      ),
      body: currentUser == null
          ? Center(
              child: Text(
                'ANDA BELUM LOGIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Berita di Simpan',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 20),
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
                      itemCount: _filteredNewsItems.length,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Information'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmark'),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number), label: 'Ticket'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildNewsItem(int index, DocumentSnapshot articleSnapshot) {
    String category = articleSnapshot['kategori'] ?? 'No Category';
    String title = articleSnapshot['judul_artikel'] ?? 'No Title';
    Timestamp timestamp = articleSnapshot['tanggal_upload'];
    String date = DateFormat('dd MMMM yyyy').format(timestamp.toDate());
    String imagePath = articleSnapshot['gambar_url'] ??
        'https://example.com/default-image.png';
    String docId = articleSnapshot.id;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.READ_FAVORITE, arguments: articleSnapshot.data());
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
          ],
        ),
      ),
    );
  }
}
