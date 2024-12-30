import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/app/modules/ticket_saya/controllers/ticket_saya_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';

class HalamanHistoryTicketView extends StatefulWidget {
  const HalamanHistoryTicketView({super.key});

  @override
  _HalamanHistoryTicketViewState createState() =>
      _HalamanHistoryTicketViewState();
}

class _HalamanHistoryTicketViewState extends State<HalamanHistoryTicketView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _borderColorAnimation;
  RxBool isTicketPurchased = false.obs;
  RxList<Map<String, dynamic>> ticketsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTicketsList =
      <Map<String, dynamic>>[].obs;
  stt.SpeechToText _speechToText =
      stt.SpeechToText(); // Instance untuk Speech-to-Text
  bool _isListening = false; // Status apakah sedang mendengarkan suara
  String _searchQuery = ""; // Query pencarian
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi AnimationController untuk warna border
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(); // Looping animation setiap 5 detik

    // Inisialisasi ColorTween untuk animasi warna border
    _borderColorAnimation = ColorTween(
      begin: Colors.blue, // Warna awal
      end: Colors.red, // Warna akhir
    ).animate(_controller);

    _speechToText.initialize();
  }

  @override
  void dispose() {
    _controller.dispose(); // Pastikan controller dibersihkan
    super.dispose();
  }

  // Fungsi untuk memulai mendengarkan suara
  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _searchQuery = result.recognizedWords; // Menyimpan kata yang dikenali
          _searchController.text =
              _searchQuery; // Menampilkan hasil suara pada TextField
          _searchTickets(_searchQuery); // Mencari tiket berdasarkan query suara
        });
      });
    }
  }

  // Fungsi untuk menghentikan pendengaran
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

// Fungsi untuk melakukan pencarian berdasarkan query
  void _searchTickets(String query) {
    if (query.isEmpty) {
      filteredTicketsList.value =
          ticketsList; // Menampilkan semua tiket jika pencarian kosong
    } else {
      filteredTicketsList.value = ticketsList.where((ticket) {
        var ticketDetails = ticket['ticket_details'];

        // Normalisasi string dan memeriksa apakah query ada dalam field
        // Tanpa mempedulikan kapitalisasi huruf
        return _normalizeString(ticket['name'])
                .contains(_normalizeString(query)) ||
            _normalizeString(ticketDetails['data_tiket']['tim_away'])
                .contains(_normalizeString(query)) ||
            _normalizeString(ticketDetails['data_tiket']['tim_home'])
                .contains(_normalizeString(query));
      }).toList();
    }
  }

// Fungsi untuk normalisasi string (menghilangkan spasi dan huruf kapital)
  String _normalizeString(String input) {
    return input
        .replaceAll(RegExp(r'\s+'), '')
        .toLowerCase(); // Menghapus spasi dan mengubah ke lowercase
  }

  @override
  Widget build(BuildContext context) {
    // Variabel untuk status apakah tiket sudah dibeli
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.delayed(Duration.zero, () {
        Get.toNamed('/login'); // Ganti '/login' dengan route halaman login Anda
      });
      return Center(child: CircularProgressIndicator());
    }

    // Mendapatkan data transaksi tiket dari Firestore
    FirebaseFirestore.instance
        .collection('history_ticket')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        isTicketPurchased.value = true;
        ticketsList.value = querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList();
        filteredTicketsList.value =
            ticketsList; // Set filtered list to all tickets initially
      } else {
        isTicketPurchased.value = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Tiket yang Pernah dibeli'),
        centerTitle: true,
        backgroundColor: Color(0xFF1A237E),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (!isTicketPurchased.value) {
          return Center(
            child: Text(
              "Anda belum membeli tiket",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return Column(
            children: [
              // Pencarian Tiket dengan TextField
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Cari Tiket (ID, Nama, Tim)",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          _searchTickets(query);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(_isListening ? Icons.stop : Icons.mic),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                  ],
                ),
              ),
              // List Tiket
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTicketsList.length,
                  itemBuilder: (context, index) {
                    var ticket = filteredTicketsList[index];
                    var ticketDetails = ticket['ticket_details'];
                    var ticketData = ticket['ticket_data'];

                    // Mendapatkan informasi waktu pertandingan
                    Timestamp timestamp = ticketDetails['data_tiket']['waktu'];
                    Timestamp timestamp2 = ticket['timestamp'];

                    if (timestamp != null) {
                      DateTime purchaseTime =
                          DateTime.fromMillisecondsSinceEpoch(
                              timestamp2.seconds * 1000);
                      String purchaseDateStr =
                          DateFormat('dd MMMM yyyy').format(purchaseTime);
                      String purchaseTimeStr =
                          DateFormat('HH:mm').format(purchaseTime);

                      int seconds = timestamp.seconds;
                      DateTime matchTime =
                          DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
                      String matchTimeStr =
                          DateFormat('HH:mm').format(matchTime);
                      String matchDateStr =
                          DateFormat('dd MMMM yyyy').format(matchTime);

                      String match =
                          "${ticketDetails['data_tiket']['tim_home']} vs ${ticketDetails['data_tiket']['tim_away']}";
                      String stadiumName = ticketDetails['data_tiket']
                              ['tempat'] ??
                          'Nama tempat tidak tersedia';

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            showLocationDialog(context, stadiumName);
                          },
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _borderColorAnimation.value ??
                                        Colors.blue,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: child,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama: ${ticket['name']}",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Text("Pertandingan: $match",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Text("Tempat: $stadiumName",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                // Menampilkan waktu pertandingan dengan format yang sudah ditentukan
                                Text("Tanggal Main: $matchDateStr",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Text("Pukul: $matchTimeStr",
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                // Menampilkan data tiket
                                Container(
                                  padding: EdgeInsets.all(
                                      16), // Padding di dalam container untuk semua teks
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Warna latar belakang di dalam container
                                    border: Border.all(
                                      color: Colors.blue, // Warna border
                                      width: 2, // Lebar border
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        8), // Sudut membulat pada border
                                  ),
                                  width: double
                                      .infinity, // Membuat lebar container mentok kiri dan kanan
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Teks mulai dari kiri
                                    children: [
                                      // Teks "Data Tiket"
                                      Text(
                                        "Data Tiket:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10), // Jarak antar teks

                                      // Teks "Jenis Tiket"
                                      for (var jenisTicket
                                          in ticketData.keys) ...[
                                        Text(
                                          "Jenis Tiket: $jenisTicket",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                            height: 10), // Jarak antar teks

                                        // Teks "ID Kursi" di dalam border
                                        for (var kursi
                                            in ticketData[jenisTicket]) ...[
                                          Text(
                                            "ID Kursi: ${kursi['id']} $jenisTicket",
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 0, 8, 255),
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ), // Jarak antar teks
                                        ],
                                      ],
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),
                                // Menampilkan data tiket
                                Text("Pembelian Tiket dilakukan pada:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                // Menampilkan waktu pertandingan dengan format yang sudah ditentukan
                                Text(
                                    "Tanggal: $purchaseDateStr", // Menampilkan tanggal pembelian tiket
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Text(
                                    "Waktu: $purchaseTimeStr", // Menampilkan waktu pembelian tiket
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
// Menambahkan teks catatan
                                Text(
                                  "Note: Klik ticket card untuk menampilkan lokasi dan jarak Anda kepada stadion.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: const Color.fromARGB(
                                          164, 255, 41, 41)),
                                ),
                                SizedBox(height: 20),
                                Divider(),
                                Center(
                                  child: Text("Tiket Berhasil Dibeli!",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.green)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("Waktu pertandingan tidak tersedia",
                            style: TextStyle(fontSize: 18, color: Colors.red)),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  void showLocationDialog(BuildContext context, String stadiumName) {
    final controller = Get.find<TicketSayaController>(); // Mengakses controller

    // Menampilkan dialog terlebih dahulu
    showDialog(
      context: context,
      builder: (context) {
        // Placeholder untuk dialog, akan diupdate setelah mendapatkan data
        return AlertDialog(
          title: Text('Lokasi Anda'),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: Center(
              child: CircularProgressIndicator(), // Loading spinner
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );

    // Ambil lokasi pengguna menggunakan Geolocator
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      double userLatitude = position.latitude;
      double userLongitude = position.longitude;

      // Memanggil fungsi untuk mendapatkan lokasi stadion berdasarkan nama
      controller.getCoordinatesFromAddress(stadiumName).then((coordinates) {
        double? stadiumLatitude = coordinates['latitude'];
        double? stadiumLongitude = coordinates['longitude'];

        // Tutup dialog loading
        Navigator.of(context).pop();

        // Tampilkan dialog baru dengan lokasi
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Lokasi Anda'),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    // Map
                    Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(userLatitude, userLongitude),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              // Marker untuk lokasi user (merah)
                              Marker(
                                point: LatLng(userLatitude, userLongitude),
                                width: 40.0,
                                height: 40.0,
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                              if (stadiumLatitude != null &&
                                  stadiumLongitude != null)
                                Marker(
                                  point:
                                      LatLng(stadiumLatitude, stadiumLongitude),
                                  width: 40.0,
                                  height: 40.0,
                                  child: Icon(
                                    Icons.flag,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                            ],
                          ),
                          if (stadiumLatitude != null &&
                              stadiumLongitude != null)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: [
                                    LatLng(userLatitude, userLongitude),
                                    LatLng(stadiumLatitude, stadiumLongitude),
                                  ],
                                  strokeWidth: 4.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Menampilkan lokasi pengguna
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Latitude, Longitude',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: '$userLatitude, $userLongitude',
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: 10),
                    // Jika lokasi stadion ditemukan, tampilkan nama stadion dan jarak
                    if (stadiumLatitude != null &&
                        stadiumLongitude != null) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Tempat',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(text: stadiumName),
                        readOnly: true,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Jarak ke stadion: ${(Geolocator.distanceBetween(userLatitude, userLongitude, stadiumLatitude, stadiumLongitude) / 1000).toStringAsFixed(2)} km',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tutup'),
                ),
              ],
            );
          },
        );
      }).catchError((e) {
        // Tangani error jika stadion tidak ditemukan
        Navigator.of(context).pop(); // Tutup dialog loading
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Lokasi Anda'),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(userLatitude, userLongitude),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(userLatitude, userLongitude),
                                width: 40.0,
                                height: 40.0,
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Latitude, Longitude',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: '$userLatitude, $userLongitude',
                      ),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tutup'),
                ),
              ],
            );
          },
        );
      });
    }).catchError((e) {
      // Tangani error jika lokasi pengguna tidak dapat diambil
      Get.snackbar(
        'Gagal Mengambil Lokasi',
        'Tidak dapat mengambil lokasi Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }
}
