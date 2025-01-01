import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/Halaman_AremaDay/views/halaman_arema_day_view.dart';
import 'package:myapp/app/modules/Halaman_Aremania/views/halaman_aremania_view.dart';
import 'package:myapp/app/modules/Halaman_Berita_Terbaru/views/halaman_berita_terbaru_view.dart';
import 'package:myapp/app/modules/Halaman_Trending/views/halaman_trending_view.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedMenuIndex = 0;
  final HomeController homeController123 = Get.put(HomeController());
  TextEditingController _searchController =
      TextEditingController(); // Controller pencarian
  List<DocumentSnapshot> _newsItems = []; // Menyimpan dokumen berita
  List<DocumentSnapshot> _filteredNewsItems =
      []; // Menyimpan hasil filter pencarian
  @override
  void initState() {
    super.initState(); // Panggil fungsi untuk mengambil data bookmarks
    _searchController
        .addListener(_filterNews); // Menambahkan listener untuk pencarian
    _speech = stt.SpeechToText();
  }

  // Speech to Text variables
  late stt.SpeechToText _speech;
  bool _isListening = false;

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech Status: $status"),
      onError: (error) => print("Speech Error: $error"),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
        });
      });
    } else {
      print("Speech recognition tidak tersedia");
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

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
              builder: (context) =>
                  HalamanBeritaTerbaruView()), // Replace with your page
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HalamanTrendingView()), // Replace with your page
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HalamanAremaDayView()), // Replace with your page
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HalamanAremaniaView()), // Replace with your page
        );
        break;
      default:
        break;
    }
  }

  void _filterNews() {
    String query =
        _searchController.text.toLowerCase(); // Ambil query pencarian
    print("Pencarian: $query"); // Debugging: tampilkan kata kunci pencarian

    if (query.isEmpty) {
      // Jika pencarian kosong, tampilkan semua artikel
      setState(() {
        _filteredNewsItems = List.from(_newsItems); // Kembalikan semua item
      });
    } else {
      // Jika ada query pencarian, filter artikel berdasarkan judul
      setState(() {
        _filteredNewsItems = _newsItems.where((newsItem) {
          String title = (newsItem['judul_artikel'] ?? '')
              .toLowerCase(); // Periksa field judul
          bool containsQuery =
              title.contains(query); // Pencocokan kata kunci di judul artikel
          print(
              "Artikel: $title, Pencarian cocok: $containsQuery"); // Debugging: cek pencocokan
          return containsQuery;
        }).toList();
      });
    }

    print(
        "Jumlah hasil pencarian: ${_filteredNewsItems.length}"); // Debugging: tampilkan hasil pencarian
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Jika izin belum diberikan, minta izin kepada pengguna
      await Permission.microphone.request();
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
              icon: Icon(
                Icons.person,
                color: Colors.grey,
                size: 35,
              ),
              onPressed: () async {
                await homeController123.checkLoginStatus(); // Cek status login
                if (homeController123.isLoggedIn.value) {
                  // Jika sudah login, arahkan ke halaman profil
                  Get.toNamed(Routes.HALAMAN_PROFILE);
                } else {
                  // Jika belum login, arahkan ke halaman login
                  Get.toNamed(Routes.HALAMAN_LOGIN);
                }
              },
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
                    Text("Selamat Datang!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    // IconButton(
                    //   icon: Icon(Icons.notifications,
                    //       color: Colors.grey), // Icon lonceng di kanan
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                // Tanggal yang diperbarui secara real-time
                StreamBuilder<DateTime>(
                  stream: Stream.periodic(Duration(seconds: 1),
                      (_) => DateTime.now()), // Update setiap detik
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(); // Menunggu data pertama
                    }
                    DateTime currentTime = snapshot.data!;
                    String formattedDate =
                        DateFormat('EEEE, dd MMMM yyyy').format(currentTime);

                    return Text(
                      "$formattedDate",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                SizedBox(height: 20),

                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Pencarian...",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_menuTitles.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
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

// Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Berita Terbaru",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    // TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),

// Berita Terbaru Cards - Memodifikasi agar menampilkan hasil pencarian
                // Pada bagian kode StreamBuilder:
                Container(
                  height: 290, // Sesuaikan tinggi sesuai kebutuhan
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Home')
                        .where('kategori', isEqualTo: 'beritaterbaru')
                        .orderBy('tanggal_upload', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Articles Available'));
                      }

                      // Filter berita berdasarkan pencarian
                      String query = _searchController.text.toLowerCase();
                      List<DocumentSnapshot> filteredDocs =
                          snapshot.data!.docs.where((doc) {
                        String title =
                            (doc['judul_artikel'] ?? '').toLowerCase();
                        return title.contains(
                            query); // Pencocokan judul artikel dengan query pencarian
                      }).toList();

                      // Menampilkan hasil pencarian atau semua artikel jika tidak ada pencarian
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final articleData = filteredDocs[index];
                          return _buildArticleCard(
                              articleData); // Menampilkan artikel
                        },
                      );
                    },
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
                    // TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Trending Cards
                Container(
                  height: 290, // Sesuaikan tinggi sesuai kebutuhan
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Home')
                        .where('kategori', isEqualTo: 'trending')
                        .orderBy('tanggal_upload', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Articles Available'));
                      }

                      // Filter berita berdasarkan pencarian
                      String query = _searchController.text.toLowerCase();
                      List<DocumentSnapshot> filteredDocs =
                          snapshot.data!.docs.where((doc) {
                        String title =
                            (doc['judul_artikel'] ?? '').toLowerCase();
                        return title.contains(
                            query); // Pencocokan judul artikel dengan query pencarian
                      }).toList();

                      // Menampilkan hasil pencarian atau semua artikel jika tidak ada pencarian
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final articleData = filteredDocs[index];
                          return _buildArticleCard(
                              articleData); // Menampilkan artikel
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),
                // Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Arema Day",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    // TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                SizedBox(height: 10),
                // Berita Terbaru Cards
                Container(
                  height: 290, // Sesuaikan tinggi sesuai kebutuhan
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Home')
                        .where('kategori', isEqualTo: 'aremaday')
                        .orderBy('tanggal_upload', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Articles Available'));
                      }

                      // Filter berita berdasarkan pencarian
                      String query = _searchController.text.toLowerCase();
                      List<DocumentSnapshot> filteredDocs =
                          snapshot.data!.docs.where((doc) {
                        String title =
                            (doc['judul_artikel'] ?? '').toLowerCase();
                        return title.contains(
                            query); // Pencocokan judul artikel dengan query pencarian
                      }).toList();

                      // Menampilkan hasil pencarian atau semua artikel jika tidak ada pencarian
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final articleData = filteredDocs[index];
                          return _buildArticleCard(
                              articleData); // Menampilkan artikel
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Tabs dan konten Berita Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aremania / nita",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    // TextButton(onPressed: () {}, child: Text("Lihat Semua")),
                  ],
                ),
                Container(
                  height: 290, // Sesuaikan tinggi sesuai kebutuhan
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Home')
                        .where('kategori', isEqualTo: 'aremania')
                        .orderBy('tanggal_upload', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No Articles Available'));
                      }

                      // Filter berita berdasarkan pencarian
                      String query = _searchController.text.toLowerCase();
                      List<DocumentSnapshot> filteredDocs =
                          snapshot.data!.docs.where((doc) {
                        String title =
                            (doc['judul_artikel'] ?? '').toLowerCase();
                        return title.contains(
                            query); // Pencocokan judul artikel dengan query pencarian
                      }).toList();

                      // Menampilkan hasil pencarian atau semua artikel jika tidak ada pencarian
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final articleData = filteredDocs[index];
                          return _buildArticleCard(
                              articleData); // Menampilkan artikel
                        },
                      );
                    },
                  ),
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

  Widget _buildArticleCard(DocumentSnapshot articleData) {
    return GestureDetector(
      onTap: () async {
        String articleId = articleData.id; // Ambil ID artikel
        var articleDetails = articleData.data(); // Ambil data artikel

        // Kirim ID dan data artikel ke halaman NGALAM_READ_TERBARU
        Get.toNamed(
          Routes.READDETAILARTIKEL,
          arguments: {
            'id': articleId, // Mengirimkan ID artikel
            'data': articleDetails, // Mengirimkan data artikel
          },
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Durasi animasi border
        width: 330, // Set width untuk setiap card
        margin: EdgeInsets.only(right: 9), // Jarak antar card
        child: Card(
          elevation: 8, // Memberikan efek shadow pada card
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Sudut melengkung untuk Card luar
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(15), // Sudut melengkung untuk Card dalam
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    15), // Sudut melengkung untuk Card dalam
              ),
              child: Stack(
                children: [
                  // Gambar akan menutupi seluruh card dan diberi transparansi
                  articleData['gambar_url'] != null
                      ? Positioned.fill(
                          child: Image.network(
                            articleData['gambar_url'],
                            fit: BoxFit
                                .cover, // Gambar mengisi seluruh area card
                            color: const Color.fromARGB(0, 0, 0, 0)
                                .withOpacity(0), // Menambahkan transparansi
                            colorBlendMode: BlendMode
                                .darken, // Membuat gambar lebih gelap dengan transparansi
                          ),
                        )
                      : Positioned.fill(
                          child: Container(
                            color: Colors.grey[300],
                            child: Center(child: Text('No Image')),
                          ),
                        ),
                  // Lapisan semi-transparan di atas gambar agar teks lebih terlihat
                  Positioned.fill(
                    child: Container(
                      color:
                          Colors.black.withOpacity(0.4), // Transparansi hitam
                    ),
                  ),
                  // Teks berada di atas gambar
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articleData['judul_artikel'] ?? 'No Title',
                            style: TextStyle(
                              fontFamily: 'Montserrat', // Gunakan Montserrat
                              fontWeight:
                                  FontWeight.w900, // Gunakan Black (tertebal)
                              fontSize: 20,
                              color: Colors
                                  .white, // Sesuaikan dengan warna teks yang diinginkan
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.account_circle,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                articleData['nama_upload'] ?? 'Unknown Author',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.remove_red_eye,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                articleData['tanggal_upload'] != null
                                    ? DateFormat('dd MMMM yyyy').format(
                                        articleData['tanggal_upload']
                                            .toDate()) // Menampilkan tanggal, bulan dan tahun
                                    : 'No Date',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
          ),
        ),
      ),
    );
  }
  // Perbaikan pada fungsi _buildArticleCard
  // Widget _buildArticleCard(DocumentSnapshot articleData) {
  //   return GestureDetector(
  //     onTap: () async {
  //       // Delay sebelum pindah halaman
  //       await Future.delayed(Duration(milliseconds: 200));

  //       setState(() {
  //         _gradientStartColor =
  //             Colors.orange.withOpacity(0.6); // Warna gradien mulai
  //         _gradientEndColor = const Color.fromARGB(255, 0, 149, 255)
  //             .withOpacity(0.3); // Warna gradien akhir
  //       });
  //       // Menunggu beberapa detik dan kemudian kembalikan ke warna semula
  //       await Future.delayed(Duration(milliseconds: 200));
  //       setState(() {
  //         // Kembalikan warna ke warna semula
  //         _gradientStartColor = const Color.fromARGB(255, 0, 17, 47)
  //             .withOpacity(0.6); // Warna awal
  //         _gradientEndColor = const Color.fromARGB(255, 0, 140, 255)
  //             .withOpacity(0.3); // Warna awal
  //       });

  //       String articleId = articleData.id; // Ambil ID artikel
  //       var articleDetails = articleData.data(); // Ambil data artikel

  //       // Kirim ID dan data artikel ke halaman NGALAM_READ_TERBARU
  //       Get.toNamed(
  //         Routes.READDETAILARTIKEL,
  //         arguments: {
  //           'id': articleId, // Mengirimkan ID artikel
  //           'data': articleDetails, // Mengirimkan data artikel
  //         },
  //       );
  //     },
  //     child: AnimatedContainer(
  //       duration: Duration(milliseconds: 300), // Durasi animasi border
  //       width: 240, // Set width untuk setiap card
  //       margin: EdgeInsets.only(right: 9), // Jarak antar card
  //       child: Card(
  //         elevation: 8, // Memberikan efek shadow pada card
  //         shape: RoundedRectangleBorder(
  //           borderRadius:
  //               BorderRadius.circular(15), // Sudut melengkung untuk Card luar
  //         ),
  //         child: ClipRRect(
  //           borderRadius:
  //               BorderRadius.circular(15), // Sudut melengkung untuk Card dalam
  //           child: Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   _gradientStartColor,
  //                   _gradientEndColor,
  //                 ], // Efek gradasi dengan warna yang berubah
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               borderRadius: BorderRadius.circular(
  //                   15), // Sudut melengkung untuk Card dalam
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 articleData['gambar_url'] != null
  //                     ? Image.network(
  //                         articleData['gambar_url'],
  //                         fit: BoxFit.cover,
  //                         height: 150,
  //                         width: double.infinity,
  //                       )
  //                     : Container(
  //                         color: Colors.grey[300],
  //                         height: 120,
  //                         width: double.infinity,
  //                         child: Center(child: Text('No Image')),
  //                       ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         articleData['judul_artikel'] ?? 'No Title',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w900,
  //                           fontSize: 20,
  //                           color: Colors.white, // Warna teks putih
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       SizedBox(height: 5),
  //                       Row(
  //                         children: [
  //                           Icon(Icons.account_circle,
  //                               size: 12, color: Colors.white),
  //                           SizedBox(width: 5),
  //                           Text(
  //                             articleData['nama_upload'] ?? 'Unknown Author',
  //                             style:
  //                                 TextStyle(color: Colors.white, fontSize: 17),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(height: 5),
  //                       Row(
  //                         children: [
  //                           Icon(Icons.remove_red_eye,
  //                               size: 12, color: Colors.white),
  //                           SizedBox(width: 5),
  //                           Text(
  //                             articleData['tanggal_upload'] != null
  //                                 ? DateFormat('dd MMMM yyyy').format(articleData[
  //                                         'tanggal_upload']
  //                                     .toDate()) // Menampilkan tanggal, bulan dan tahun
  //                                 : 'No Date',
  //                             style:
  //                                 TextStyle(color: Colors.white, fontSize: 16),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
