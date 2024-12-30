import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManagementKursiView extends StatefulWidget {
  final String docId1;

  AdminManagementKursiView({required this.docId1});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<AdminManagementKursiView> {
  List<String> _ticketTypes = [];
  String _selectedTicketType = '';
  Map<String, List<String>> _selectedSeatsByType = {};

  // List<Map<String, dynamic>> _selectedSeats = [];
  Map<String, List<Map<String, dynamic>>> _seats = {};
  List<Map<String, dynamic>> jenisTiketList = [];

  final int _seatsPerPage = 50; // Menampilkan 50 kursi per halaman

  int _currentSeatPage = 0;

  double _ticketPrice = 0.0;

  late DocumentSnapshot ticketDoc; // Ticket document snapshot
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTicketData(); // Ambil data tiket saat initState
  }

  Future<void> _fetchTicketData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('ticket')
          .doc(widget.docId1)
          .get();

      final ticketData = docSnapshot.data();
      print('Ticket Data: $ticketData'); // Debugging: Check the received data

      if (ticketData != null && ticketData['jenis_tiket'] != null) {
        final fetchedJenisTiketList =
            List<Map<String, dynamic>>.from(ticketData['jenis_tiket']);
        print(
            'Jenis Tiket: $fetchedJenisTiketList'); // Debugging: Check jenis_tiket

        setState(() {
          // Save ticket data into state
          jenisTiketList = fetchedJenisTiketList;
          _ticketTypes =
              jenisTiketList.map((e) => e.keys.first as String).toList();
          _seats = {
            for (var tiket in jenisTiketList)
              tiket.keys.first:
                  List<Map<String, dynamic>>.from(tiket[tiket.keys.first]),
          };

          // Set default ticket type if available
          _selectedTicketType =
              _ticketTypes.isNotEmpty ? _ticketTypes.first : '';

          // Update ticket price based on selected ticket type
          if (_selectedTicketType.isNotEmpty) {
            final selectedTicket = jenisTiketList.firstWhere(
              (e) => e.keys.first == _selectedTicketType,
              orElse: () {
                return {'name': '', 'harga': 0.0, 'kursi': []};
              },
            );

            // Ambil data kursi dari jenis tiket yang dipilih
            final ticketTypeData = selectedTicket[_selectedTicketType];

            // Jika data kursi ada dan tidak kosong
            if (ticketTypeData != null && ticketTypeData.isNotEmpty) {
              // Ambil harga tiket dari kursi pertama
              _ticketPrice = (ticketTypeData[0]['harga'] as num).toDouble();
            } else {
              _ticketPrice = 0.0; // Set default jika tidak ada harga
            }

            print(
                'Ticket Price: $_ticketPrice'); // Debugging: Check ticket price
          }
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching ticket data: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3250)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Management Kursi',
          style: TextStyle(
            color: Color(0xFF2D3250),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Detail Tiket Section
              _buildSectionTitle(
                  'Detail Tiket', Icons.confirmation_number_outlined),
              SizedBox(height: 16),
              Text(
                'ID Dokumen Tiket: ${widget.docId1}', // Menampilkan ID Dokumen
                style: TextStyle(
                  color: Color(0xFF2D3250),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              _buildTicketDropdown(),
              SizedBox(height: 16),

              // Kursi Section
              _buildSeatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF2D3250)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF2D3250),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketDropdown() {
    return DropdownButton<String>(
      value: _selectedTicketType.isEmpty ? null : _selectedTicketType,
      onChanged: (newValue) {
        setState(() {
          _selectedTicketType = newValue!;
        });
      },
      hint: Text('Pilih Jenis Tiket'),
      isExpanded: true,
      items: _ticketTypes.toSet().map((ticketType) {
        // Menggunakan Set untuk menghilangkan duplikat
        return DropdownMenuItem<String>(
          value: ticketType,
          child: Text(ticketType),
        );
      }).toList(),
    );
  }

  Widget _buildSeatsSection() {
    List<Map<String, dynamic>> availableSeats =
        _seats[_selectedTicketType] ?? [];
    _selectedSeatsByType[_selectedTicketType] ??= [];

    // Mendapatkan kursi yang sesuai dengan halaman yang sedang dipilih
    List<Map<String, dynamic>> seatsToDisplay =
        _getSeatsForPage(availableSeats);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Kursi (${_selectedTicketType})',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // Show 5 seats per row
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

            // Menentukan warna kursi berdasarkan status
            if (seatStatus == 'Available') {
              seatColor = isSelected
                  ? const Color.fromRGBO(0, 123, 255, 1) // Selected
                  : const Color.fromRGBO(40, 167, 69, 1); // Available
            } else if (seatStatus == 'Verifying') {
              seatColor = Colors.grey; // Verifying
            } else if (seatStatus == 'Booked') {
              seatColor = Colors.red; // Booked
            } else {
              seatColor = Colors.grey; // Default untuk status tidak dikenali
            }

            // Semua kursi dapat diklik
            return GestureDetector(
              onTap: () {
                _showStatusChangeDialog(
                    seatId, seatStatus); // Menampilkan dialog status
              },
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
              backgroundColor:
                  Color.fromRGBO(112, 128, 144, 1), // Warna teks putih
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Sudut membulat
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
              backgroundColor:
                  Color.fromRGBO(112, 128, 144, 1), // Warna teks putih
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Sudut membulat
              ),
            ),
            child: Text('Tampilkan Kursi Sebelumnya'),
          ),
      ],
    );
  }

  void _showStatusChangeDialog(String seatId, String currentStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newStatus = currentStatus;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text('Silahkan Ubah Status Kursi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Available'),
                    leading: Radio<String>(
                      value: 'Available',
                      groupValue: newStatus,
                      onChanged: (String? value) {
                        setStateDialog(() {
                          newStatus = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Verifying'),
                    leading: Radio<String>(
                      value: 'Verifying',
                      groupValue: newStatus,
                      onChanged: (String? value) {
                        setStateDialog(() {
                          newStatus = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Booked'),
                    leading: Radio<String>(
                      value: 'Booked',
                      groupValue: newStatus,
                      onChanged: (String? value) {
                        setStateDialog(() {
                          newStatus = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Menutup dialog tanpa mengubah status
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    // Update status kursi di Firestore
                    await _updateSeatStatusInFirestore(seatId, newStatus);

                    // Setelah berhasil memperbarui status, langsung perbarui state lokal
                    setState(() {
                      var ticketSeats = _seats[_selectedTicketType];
                      for (var seat in ticketSeats!) {
                        if (seat['id'] == seatId) {
                          seat['status'] =
                              newStatus; // Update status di state lokal
                          break;
                        }
                      }
                    });

                    Navigator.pop(
                        context); // Menutup dialog setelah status diperbarui
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateSeatStatusInFirestore(
      String seatId, String newStatus) async {
    try {
      var selectedTicket = jenisTiketList.firstWhere(
        (ticket) => ticket.keys.first == _selectedTicketType,
        orElse: () => {},
      );

      if (selectedTicket.isEmpty) {
        print("Jenis tiket tidak ditemukan");
        return;
      }

      var ticketSeats = selectedTicket[_selectedTicketType];

      // Pastikan data adalah List<Map<String, dynamic>>
      if (ticketSeats is List<dynamic>) {
        ticketSeats = ticketSeats.map((seat) {
          if (seat is Map<String, dynamic>) {
            return seat;
          } else {
            throw Exception("Invalid seat data: ${seat.runtimeType}");
          }
        }).toList();
      }

      for (var seat in ticketSeats) {
        if (seat['id'] == seatId) {
          seat['status'] = newStatus;
          break;
        }
      }

      var updatedTicketList = jenisTiketList.map((ticket) {
        if (ticket.keys.first == _selectedTicketType) {
          return {
            _selectedTicketType: List<Map<String, dynamic>>.from(ticketSeats),
          };
        }
        return ticket;
      }).toList();

      await FirebaseFirestore.instance
          .collection('ticket')
          .doc(widget.docId1)
          .update({
        'jenis_tiket': updatedTicketList,
      });

      print('Status kursi berhasil diperbarui di Firestore');

      setState(() {
        _seats[_selectedTicketType] = ticketSeats;
      });
    } catch (e) {
      print('Error updating seat status in Firestore: $e');
    }
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
}
