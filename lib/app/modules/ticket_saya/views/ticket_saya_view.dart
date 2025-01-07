import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/app/modules/ticket_saya/controllers/ticket_saya_controller.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Menambahkan speech_to_text

class TicketSayaView extends StatefulWidget {
  const TicketSayaView({super.key});

  @override
  _TicketSayaViewState createState() => _TicketSayaViewState();
}

class _TicketSayaViewState extends State<TicketSayaView> {
  stt.SpeechToText _speechToText =
      stt.SpeechToText(); // Instance untuk speech-to-text
  bool _isListening = false; // Status apakah sedang mendengarkan suara
  String _searchQuery = ""; // Query pencarian
  TextEditingController _searchController =
      TextEditingController(); // Controller untuk TextField Pencarian

  RxBool isTicketPurchased = false.obs;
  RxList<Map<String, dynamic>> ticketsList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredTicketsList =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    _speechToText.initialize(); // Inisialisasi speech_to_text
    TicketSayaController().requestLocationPermission();
  }

  // Fungsi untuk mulai mendengarkan input suara
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

  // Fungsi untuk berhenti mendengarkan input suara
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
            _normalizeString(ticket['ticket_details']['id_ticket'])
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.delayed(Duration.zero, () {
        Get.toNamed('/login');
      });
      return Center(child: CircularProgressIndicator());
    }

    FirebaseFirestore.instance
        .collection('transaksi_ticket_valid')
        .where('uid', isEqualTo: user.uid)
        .snapshots()
        .listen((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        isTicketPurchased.value = true;
        ticketsList.value = querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList();
        filteredTicketsList.value =
            ticketsList; // Menyimpan tiket yang ditemukan
        _checkExpiredTickets(querySnapshot);
      } else {
        isTicketPurchased.value = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Saya'),
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
              "Anda belum memiliki tiket",
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
                    // TextField untuk pencarian
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Cari Tiket (Kode Tiket, Nama, Tim)",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (query) {
                          _searchTickets(query);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    // Tombol untuk mengaktifkan speech-to-text
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
                  itemCount:
                      filteredTicketsList.length, // Gunakan filteredTicketsList
                  itemBuilder: (context, index) {
                    var ticket = filteredTicketsList[index];
                    var ticketData = ticket['ticket_data'];
                    var ticketDetails = ticket['ticket_details'];

                    // Mendapatkan informasi waktu pertandingan
                    Timestamp timestamp = ticketDetails['data_tiket']
                        ['waktu']; // Mengambil Timestamp
                    Timestamp timestamp2 =
                        ticket['timestamp']; // Ambil timestamp dari Firestore

                    // Mengkonversi timestamp menjadi DateTime
                    DateTime purchaseTime = DateTime.fromMillisecondsSinceEpoch(
                        timestamp2.seconds * 1000);

                    // Menggunakan DateFormat untuk format tanggal dan waktu
                    String purchaseDateStr =
                        DateFormat('dd MMMM yyyy').format(purchaseTime);
                    String purchaseTimeStr =
                        DateFormat('HH:mm').format(purchaseTime);

                    int seconds = timestamp.seconds;
                    DateTime matchTime =
                        DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

                    // Menggunakan DateFormat untuk menampilkan waktu yang diformat
                    String matchTimeStr = DateFormat('HH:mm').format(matchTime);
                    String matchDateStr =
                        DateFormat('dd MMMM yyyy').format(matchTime);

                    // Mendapatkan informasi pertandingan tim
                    String match =
                        "${ticketDetails['data_tiket']['tim_home']} vs ${ticketDetails['data_tiket']['tim_away']}";

                    // Mendapatkan nama tempat
                    String stadiumName = ticketDetails['data_tiket']
                            ['tempat'] ??
                        'Nama tempat tidak tersedia';

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Memanggil showLocationDialog dengan stadiumName sebagai parameter
                          showLocationDialog(context, stadiumName);
                        },
                        child: TweenAnimationBuilder(
                          duration: Duration(seconds: 2),
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          builder: (context, double value, child) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(
                                        value), // Animasi pada boxShadow
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    offset: Offset(4, 4),
                                  ),
                                  BoxShadow(
                                    color: Color(0xFF0D47A1).withOpacity(value),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: child,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Tiket
                              Row(
                                children: [
                                  Icon(Icons.confirmation_number,
                                      color: Color(0xFF1A237E), size: 30),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Kode Tiket: ${ticketDetails['id_tiket']}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Informasi Tiket
                              Text("Email Pembeli: ${ticket['email']}",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Nama: ${ticket['name']}",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Nomor Telepon: ${ticket['phone']}",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Nama Pertandingan: $match",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Tempat: $stadiumName",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Tanggal: $matchDateStr",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Waktu: $matchTimeStr",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              // Container untuk detail tiket
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Data Tiket:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    for (var jenisTicket
                                        in ticketData.keys) ...[
                                      Text("Jenis Tiket: $jenisTicket",
                                          style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 10),
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
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text("Pembelian Tiket dilakukan pada:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text("Tanggal: $purchaseDateStr",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              Text("Waktu: $purchaseTimeStr",
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 10),
                              const Text(
                                "Note: Klik ticket card untuk menampilkan lokasi dan jarak Anda kepada stadion.",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(164, 255, 41, 41)),
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
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
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
                        if (stadiumLatitude != null && stadiumLongitude != null)
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
                  if (stadiumLatitude != null && stadiumLongitude != null) ...[
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
                    SizedBox(height: 10),
                    // Menambahkan catatan setelah jarak ke stadion
                    Text(
                      "Jika lokasi tidak akurat, kemungkinan nama stadion tidak terdaftar di dalam data OpenCage API.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontStyle: FontStyle.italic,
                      ),
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

void _checkExpiredTickets(QuerySnapshot querySnapshot) {
  Timer.periodic(Duration(minutes: 1), (timer) {
    final currentTime = DateTime.now();
    querySnapshot.docs.forEach((doc) {
      Timestamp timestamp = doc['ticket_details']['data_tiket']['waktu'];
      DateTime matchTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

      if (matchTime.isBefore(currentTime)) {
        // Jika waktu pertandingan sudah lewat, hapus tiket dari koleksi
        FirebaseFirestore.instance
            .collection('transaksi_ticket_valid')
            .doc(doc.id)
            .delete()
            .then((_) {
          print(
              "Tiket ${doc.id} berhasil dihapus karena sudah lewat waktunya.");
        }).catchError((error) {
          print("Terjadi kesalahan saat menghapus tiket: $error");
        });
      }
    });
  });
}
