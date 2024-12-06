import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/modules/transaksi_ticket/views/transaksi_ticket_view.dart';

class RincianTicketView extends StatelessWidget {
  final String docId;

  RincianTicketView({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rincian Tiket"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('ticket')
            .doc(docId) // Mengambil dokumen berdasarkan docId
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Tiket tidak ditemukan"));
          }

          var ticketData = snapshot.data!.data() as Map<String, dynamic>;

          // Mengonversi Timestamp menjadi DateTime
          Timestamp timestamp = ticketData['waktu'] ??
              Timestamp.now(); // Default to current time if null
          DateTime waktu = timestamp.toDate();
          String gambarUrl =
              ticketData['gambar_url'] ?? ''; // Get image URL from Firestore

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Image and Event Title
                Stack(
                  children: [
                    gambarUrl.isNotEmpty
                        ? Image.network(
                            gambarUrl, // Load image from URL
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 250,
                            width: double.infinity,
                            color:
                                Colors.grey[300], // Fallback color if no image
                          ),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ticketData['pertandingan'] ??
                                  'Pertandingan Tidak Diketahui', // Default value if null
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${ticketData['tim_home'] ?? 'Home Team'} vs ${ticketData['tim_away'] ?? 'Away Team'}", // Default value if null
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Match Information
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.grey[600]),
                          SizedBox(width: 10),
                          Text(
                            // Menampilkan tanggal dalam format "7 November 2024"
                            DateFormat('d MMMM y').format(
                                waktu), // Directly format the 'waktu' DateTime
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20, color: Colors.grey[600]),
                          SizedBox(width: 10),
                          Text(
                            // Format time to "15:00"
                            DateFormat('HH:mm').format(waktu),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 20, color: Colors.grey[600]),
                          SizedBox(width: 10),
                          Text(
                            ticketData['tempat'] ??
                                'Lokasi Tidak Diketahui', // Default value if null
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Match Description
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Deskripsi Pertandingan
                      SizedBox(height: 12),
                      Text(
                        ticketData['deskripsi'] ??
                            'Deskripsi Tidak Tersedia', // Default value if null
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransaksiTicketView(
                                  docId1: docId), // Kirim ID dokumen
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D3250),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Beli Tiket",
                          style: TextStyle(
                            color: Colors.white, // Paksa warna putih untuk teks
                            fontWeight: FontWeight
                                .bold, // Opsi: untuk menambahkan gaya tebal
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
