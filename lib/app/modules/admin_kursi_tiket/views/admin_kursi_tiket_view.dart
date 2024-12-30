import 'package:flutter/material.dart';
import 'package:myapp/app/modules/Admin_Management_Kursi/views/admin_management_kursi_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminKursiTiketView extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

String _selectedTicketType = '';
Map<String, double> _totalPriceByType = {};
List<String> _ticketTypes = [];
Map<String, List<String>> _selectedSeatsByType = {};
Map<String, List<Map<String, dynamic>>> _seats = {};
int _currentSeatPage = 0;
final int _seatsPerPage = 50;
double _totalPrice = 0.0;
double _ticketPrice = 0.0;

class _TicketPageState extends State<AdminKursiTiketView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Match Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Pertandingan Unggulan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('ticket')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No matches available"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var ticket = snapshot.data!.docs[index];
                          var docId = ticket.id; // Ambil ID dokumen

                          return matchCard(
                            imagePath: ticket['gambar_url'],
                            waktu: ticket['waktu'],
                            tempat: ticket['tempat'],
                            docId: docId, // Pass document ID
                            deskripsi: ticket['deskripsi'], // Add this line
                            timAway: ticket['tim_away'], // Add this line
                            timHome: ticket['tim_home'], // Add this line
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget matchCard({
    required String imagePath,
    required Timestamp waktu,
    required String tempat,
    required String docId,
    required String deskripsi,
    required String timAway,
    required String timHome,
  }) {
    final time = DateFormat('HH:mm').format(waktu.toDate());
    final date = DateFormat('dd MMMM yyyy').format(waktu.toDate());

    return GestureDetector(
      onTap: () {
        // Ketika gambar atau kartu pertandingan di klik, tampilkan dialog informasi
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Detail Pertandingan'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan gambar tiket
                    Image.network(imagePath),
                    SizedBox(height: 16),

                    // Kotak pertama: Menampilkan jadwal pertandingan
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pertandingan: $timAway VS $timHome",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Pukul: $time",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Waktu: $date",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Tempat: $tempat",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Kotak kedua: Menampilkan deskripsi
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        deskripsi,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        "$time • $date",
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        tempat,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Navigasi langsung ke halaman AdminManagementKursi
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminManagementKursiView(
                                  docId1: docId,
                                ),
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDropdown() {
    return DropdownButton<String>(
      value: _selectedTicketType.isEmpty ? null : _selectedTicketType,
      onChanged: (newValue) {
        setState(() {
          _selectedTicketType = newValue!;

          // Tambahkan default nilai untuk jenis tiket yang baru dipilih jika belum ada
          _totalPriceByType[_selectedTicketType] ??= 0.0;

          // Hitung ulang total harga global
          _calculateTotalPrice();
        });
      },
      hint: Text('Pilih Jenis Tiket'),
      isExpanded: true,
      items: _ticketTypes.map((ticketType) {
        return DropdownMenuItem<String>(
          value: ticketType,
          child: Text(ticketType),
        );
      }).toList(),
    );
  }

  Widget _buildSeatsSection() {
    // Mengambil kursi yang sesuai dengan jenis tiket yang dipilih
    List<Map<String, dynamic>> availableSeats = _seats[_selectedTicketType] ??
        []; // Pastikan kursi ada berdasarkan tipe tiket

    // Mendapatkan kursi yang sesuai dengan halaman yang sedang dipilih
    List<Map<String, dynamic>> seatsToDisplay =
        _getSeatsForPage(availableSeats);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Kursi ($_selectedTicketType)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // Menampilkan 5 kursi per baris
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: seatsToDisplay.length,
          itemBuilder: (context, index) {
            String seatId = seatsToDisplay[index]['id'];
            String seatStatus = seatsToDisplay[index]['status']; // Status kursi
            bool isSelected =
                _selectedSeatsByType[_selectedTicketType]?.contains(seatId) ??
                    false;

            // Menentukan warna berdasarkan status kursi
            Color seatColor;
            bool isClickable = true;

            if (seatStatus == 'Available') {
              seatColor = isSelected
                  ? const Color.fromRGBO(0, 123, 255, 1) // Selected
                  : const Color.fromRGBO(40, 167, 69, 1); // Available (Hijau)
            } else if (seatStatus == 'Verifying') {
              seatColor = Colors.grey; // Verifying (Abu-abu)
              isClickable = false; // Tidak bisa diklik
            } else if (seatStatus == 'Booked') {
              seatColor = Colors.red; // Booked (Merah)
              isClickable = false; // Tidak bisa diklik
            } else {
              seatColor = Colors.grey; // Default untuk status tidak dikenali
              isClickable = false; // Tidak bisa diklik
            }

            return GestureDetector(
              onTap: isClickable
                  ? () {
                      setState(() {
                        if (isSelected) {
                          _selectedSeatsByType[_selectedTicketType]
                              ?.remove(seatId);
                        } else {
                          if (_selectedSeatsByType.values
                                  .fold(0, (sum, seats) => sum + seats.length) <
                              5) {
                            _selectedSeatsByType[_selectedTicketType]
                                ?.add(seatId);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Maximal 5 kursi hanya bisa dipilih'),
                            ));
                          }
                        }

                        // Hitung total harga per jenis tiket
                        double ticketPrice = seatsToDisplay.isNotEmpty
                            ? seatsToDisplay.first['harga']?.toDouble() ?? 0.0
                            : 0.0;
                        _totalPriceByType[_selectedTicketType] = ticketPrice *
                            (_selectedSeatsByType[_selectedTicketType]
                                    ?.length ??
                                0);

                        // Hitung total harga global
                        _calculateTotalPrice();
                      });
                    }
                  : null, // Tidak melakukan aksi ketika kursi tidak bisa diklik
              child: Container(
                decoration: BoxDecoration(
                  color: seatColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chair, // Ikon kursi
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        seatId,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 23),
        // Tombol untuk menampilkan kursi berikutnya
        if (_currentSeatPage * _seatsPerPage + _seatsPerPage <
            availableSeats.length)
          TextButton(
            onPressed: () {
              setState(() {
                _currentSeatPage++;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(112, 128, 144, 1), // Warna tombol
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Tampilkan Kursi Selanjutnya'),
          ),
        if (_currentSeatPage > 0)
          TextButton(
            onPressed: () {
              setState(() {
                _currentSeatPage--;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(112, 128, 144, 1), // Warna tombol
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Tampilkan Kursi Sebelumnya'),
          ),
      ],
    );
  }

  void _calculateTotalPrice() {
    // Hitung ulang total harga global dari semua jenis tiket
    _totalPrice =
        _totalPriceByType.values.fold(0.0, (sum, price) => sum + price);
  }

  List<Map<String, dynamic>> _getSeatsForPage(
      List<Map<String, dynamic>> availableSeats) {
    int startIndex = _currentSeatPage * _seatsPerPage;
    int endIndex = startIndex + _seatsPerPage;

    // Mengambil kursi sesuai dengan halaman yang dipilih
    if (availableSeats.length <= startIndex) {
      return [];
    }

    return availableSeats.sublist(startIndex,
        endIndex > availableSeats.length ? availableSeats.length : endIndex);
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kursi yang Dipilih:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          _getSelectedSeatsInfo(),
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 16),
        Text(
          'Harga Tiket (${_selectedTicketType}): ${_ticketPrice.toString()}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Total Harga: ${_totalPrice.toString()}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getSelectedSeatsInfo() {
    String info = '';
    _selectedSeatsByType.forEach((ticketType, seats) {
      if (seats.isNotEmpty) {
        info +=
            'Jenis Tiket $ticketType: ${seats.length} kursi (${seats.join(', ')})\n';
      }
    });
    return info.isEmpty ? 'Belum ada kursi yang dipilih.' : info.trim();
  }
}
