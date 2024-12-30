import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/Favorite/views/favorite_view.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/ngalam_terbaru/views/ngalam_terbaru_view.dart';
import 'package:myapp/app/modules/ticket/views/ticket_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class TransaksiTicketView extends StatefulWidget {
  final String docId1;

  TransaksiTicketView({required this.docId1});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TransaksiTicketView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _paymentProofImage;
  String? _transactionId;

  int _selectedIndex = 3;
  List<String> _ticketTypes = [];
  String _selectedTicketType = '';
  Map<String, List<String>> _selectedSeatsByType = {};

  // List<Map<String, dynamic>> _selectedSeats = [];
  Map<String, List<Map<String, dynamic>>> _seats = {};
  List<Map<String, dynamic>> jenisTiketList = [];

  final int _seatsPerPage = 50; // Menampilkan 50 kursi per halaman

  int _currentSeatPage = 0;

  double _ticketPrice = 0.0;
  // Tambahkan Map untuk menyimpan total harga per jenis tiket
  Map<String, double> _totalPriceByType = {};

  late DocumentSnapshot ticketDoc; // Ticket document snapshot
  late String _paymentMethod = ''; // Stores the selected payment method
  late String _paymentDetails = '';
  double _totalPrice = 0.0;
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

          _totalPrice = _ticketPrice * _selectedSeatsByType.length;
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
          'Transaksi Tiket',
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
              // Kontak Detail Section
              _buildSectionTitle('Kontak Detail', Icons.person_outline),
              SizedBox(height: 16),
              _buildTextField(
                  _nameController, 'Nama Lengkap', '', Icons.person_outline),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Alamat Email', '',
                  Icons.email_outlined, TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildTextField(_phoneController, 'No Telepon', '',
                  Icons.phone_outlined, TextInputType.phone),
              SizedBox(height: 32),

              // Detail Tiket Section
              _buildSectionTitle(
                  'Detail Tiket', Icons.confirmation_number_outlined),
              SizedBox(height: 16),

              _buildTicketDropdown(),
              SizedBox(height: 16),

              // Kursi Section
              _buildSeatsSection(),
              SizedBox(height: 16),

              // Harga Section
              _buildPriceSection(),

              // Bagian metode pembayaran (sudah ada di kode sebelumnya)
              SizedBox(height: 32),
              _buildSectionTitle('Metode Pembayaran', Icons.payment),
              SizedBox(height: 16),

              Container(
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
                    DropdownButton<String>(
                      value: _paymentMethod.isEmpty ? null : _paymentMethod,
                      onChanged: (String? newMethod) async {
                        setState(() {
                          _paymentMethod = newMethod!;
                        });

                        // Ambil data dari Firestore berdasarkan metode pembayaran yang dipilih
                        final docSnapshot = await FirebaseFirestore.instance
                            .collection('ticket')
                            .doc(widget.docId1)
                            .get();
                        final ticketData = docSnapshot.data();

                        if (ticketData != null) {
                          setState(() {
                            // Update detail pembayaran sesuai metode yang dipilih
                            if (_paymentMethod == 'OVO') {
                              _paymentDetails = ticketData['ovo'] ?? '';
                            } else if (_paymentMethod == 'Dana') {
                              _paymentDetails = ticketData['dana'] ?? '';
                            } else if (_paymentMethod == 'Transfer Bank') {
                              _paymentDetails =
                                  ticketData['transfer_bank'] ?? '';
                            } else if (_paymentMethod == 'Gopay') {
                              _paymentDetails = ticketData['gopay'] ?? '';
                            } else if (_paymentMethod == 'ShopeePay') {
                              _paymentDetails = ticketData['shopeepay'] ?? '';
                            }
                          });
                        }
                      },
                      items: [
                        'Transfer Bank',
                        'Dana',
                        'ShopeePay',
                        'OVO',
                        'Gopay',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    if (_paymentMethod.isNotEmpty) ...[
                      Text('Pembayaran melalui $_paymentMethod:'),
                      SizedBox(height: 8),
                      Text(_paymentDetails, style: TextStyle(fontSize: 16)),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 32),
              // Bukti pembayaran
              _buildSectionTitle('Bukti Pembayaran', Icons.upload_file),
              SizedBox(height: 16),
              Container(
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
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.photo),
                      label: Text('Pilih Bukti Pembayaran Gambar'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _paymentProofImage != null
                        ? Image.file(
                            _paymentProofImage!,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            'Belum ada gambar dipilih',
                            style: TextStyle(color: Colors.grey),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTicketData,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Lanjutkan Pembayaran',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            icon: Icon(Icons.confirmation_number),
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

  // Method to handle the change of the payment method
  void _updatePaymentDetails(String paymentMethod) {
    setState(() {
      _paymentMethod = paymentMethod;
      _paymentDetails =
          ticketDoc[paymentMethod.toLowerCase()] ?? 'No details available';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NgalamTerbaruView()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoriteView()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Ticket_View()),
        );
        break;
    }
  }

  Future<void> _saveTicketData() async {
    // Validasi input
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedSeatsByType.isEmpty ||
        _selectedTicketType.isEmpty ||
        _paymentMethod.isEmpty ||
        _paymentProofImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lengkapi data sebelum melakukan pembayaran!"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
        ),
      );
      return;
    }

    try {
      // Upload bukti pembayaran jika ada
      String? paymentProofUrl;
      if (_paymentProofImage != null) {
        paymentProofUrl = await _uploadPaymentProof(_paymentProofImage!);
      }

      // Ambil data tiket dari Firestore
      DocumentSnapshot ticketSnapshot = await FirebaseFirestore.instance
          .collection('ticket')
          .doc(widget.docId1)
          .get();

      if (!ticketSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data tiket tidak ditemukan."),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
          ),
        );
        return;
      }

      Map<String, dynamic> ticketData =
          ticketSnapshot.data() as Map<String, dynamic>;
      List<dynamic> jenisTiket = ticketData['jenis_tiket'];

// Update status kursi yang dipilih untuk semua jenis tiket
      for (var jenis in jenisTiket) {
        (jenis as Map<String, dynamic>).forEach((ticketType, kursiList) {
          if (_selectedSeatsByType.containsKey(ticketType)) {
            List<dynamic> selectedSeats = _selectedSeatsByType[ticketType]!;
            for (var kursiData in kursiList) {
              if (selectedSeats.contains(kursiData['id'])) {
                kursiData['status'] = 'Verifying';
              }
            }
          }
        });
      }

      // Simpan kembali data tiket dengan status kursi yang diperbarui
      await FirebaseFirestore.instance
          .collection('ticket')
          .doc(widget.docId1)
          .update({'jenis_tiket': jenisTiket});

      Map<String, dynamic> ticketDetails = {
        'id_tiket': ticketSnapshot.id, // Menambahkan ID tiket
        'data_tiket': {
          'deskripsi': ticketSnapshot['deskripsi'],
          'gambar_url': ticketSnapshot['gambar_url'],
          'tempat': ticketSnapshot['tempat'],
          'tim_away': ticketSnapshot['tim_away'],
          'tim_home': ticketSnapshot['tim_home'],
          'user_id': ticketSnapshot['user_id'],
          'waktu': ticketSnapshot['waktu'],
        },
      };

      // Simpan data transaksi ke koleksi transactions
      Map<String, dynamic> transactionData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'total_price': _totalPrice,
        'payment_method': _paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
        'ticket_data': {
          for (var entry in _selectedSeatsByType.entries)
            entry.key: entry.value
                .map((seatId) {
                  // Cari detail kursi dari data tiket asli
                  var ticketTypeData = jenisTiket.firstWhere(
                      (type) => type.keys.first == entry.key,
                      orElse: () => null);

                  if (ticketTypeData != null) {
                    var seatData = (ticketTypeData[entry.key] as List)
                        .firstWhere((seat) => seat['id'] == seatId,
                            orElse: () => null);
                    if (seatData != null) {
                      return {
                        'id': seatData['id'],
                        'harga': seatData['harga'],
                        'status': 'Verifying',
                      };
                    }
                  }
                  return null; // Jika kursi tidak ditemukan, kembalikan null
                })
                .where((seat) => seat != null)
                .toList(),
        },
        'jenis_ticket': _selectedTicketType,
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'payment_proof': paymentProofUrl ?? '',
        'ticket_details': ticketDetails,
      };

      await FirebaseFirestore.instance
          .collection('transactions')
          .add(transactionData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pembelian sudah dilakukan, tunggu konfirmasi"),
          backgroundColor: Colors.green[400],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
        ),
      );

      Get.toNamed(Routes.TICKET);
    } catch (e) {
      print("Error during transaction process: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan data transaksi."),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }

  Future<String?> _uploadPaymentProof(File paymentProofImage) async {
    try {
      // Mendapatkan referensi ke Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('payment_proofs')
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      // Meng-upload gambar ke Firebase Storage
      final uploadTask = storageRef.putFile(paymentProofImage);

      // Menunggu upload selesai dan mendapatkan URL gambar
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl; // Mengembalikan URL gambar yang di-upload
    } catch (e) {
      print("Error uploading payment proof: $e");
      return null;
    }
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

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF2D3250)),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF2D3250)),
        ),
      ),
    );
  }

  Widget _buildTicketDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF2D3250)),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: Color(0xFF2D3250),
    );
  }
  // Fungsi untuk mengambil gambar dari galeri

  Future<void> _pickImage() async {
    // Membuka dialog file picker untuk memilih gambar
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _paymentProofImage =
            File(pickedFile.path); // Simpan path gambar yang dipilih
      });
    } else {
      // Jika tidak ada gambar yang dipilih, set null
      setState(() {
        _paymentProofImage = null;
      });
    }
  }

  // Fungsi untuk meng-upload bukti pembayaran
  Future<void> _savePaymentProof() async {
    if (_paymentProofImage != null) {
      // Lakukan logika penyimpanan gambar di sini (misalnya upload ke Firebase Storage)
      // Misalnya: String imageUrl = await uploadToFirebaseStorage(_paymentProofImage);
      // Kemudian simpan URL gambar ke Firestore sebagai bukti pembayaran
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pilih gambar bukti pembayaran!"),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
        ),
      );
    }
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
            bool isClickable = true;

            if (seatStatus == 'Available') {
              seatColor = isSelected
                  ? const Color.fromRGBO(0, 123, 255, 1) // Selected
                  : const Color.fromRGBO(40, 167, 69, 1); // Available
            } else if (seatStatus == 'Verifying') {
              seatColor = Colors.grey; // Verifying
              isClickable = false; // Tidak bisa diklik
            } else if (seatStatus == 'Booked') {
              seatColor = Colors.red; // Booked
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

  void _calculateTotalPrice() {
    // Hitung ulang total harga global dari semua jenis tiket
    _totalPrice =
        _totalPriceByType.values.fold(0.0, (sum, price) => sum + price);
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

  void _updateTicketPrice() {
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
          'Ticket Price Updated: $_ticketPrice'); // Debugging: Check updated ticket price
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
