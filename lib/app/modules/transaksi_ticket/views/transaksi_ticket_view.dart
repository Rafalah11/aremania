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

  int _selectedIndex = 3;
  final List<String> _ticketTypes = ['VVIP', 'VIP', 'TRIBUN'];
  String _selectedTicketType = 'VVIP';
  String? _selectedSeat;
  final Set<String> _selectedSeats = {}; // Store the selected seats
  final Set<String> _verifiedSeats = {}; // Store seats being verified (abu-abu)
  // Data kursi
  final Map<String, List<String>> _seats = {
    'VVIP': List.generate(50, (index) => 'VVIP-${index + 1}'),
    'VIP': List.generate(150, (index) => 'VIP-${index + 1}'),
    'TRIBUN': List.generate(800, (index) => 'TRIBUN-${index + 1}'),
  };

  // Kursi yang sudah dipesan
  final Set<String> _bookedSeats = {};

  int _startIndex = 0; // Indeks awal rentang kursi
  int _endIndex = 50; // Indeks akhir rentang kursi
  final int _seatsPerPage = 50; // Menampilkan 50 kursi per halaman

// Fungsi untuk memuat kursi berikutnya
  void _loadNextSeats() {
    setState(() {
      if (_endIndex < _seats[_selectedTicketType]!.length) {
        _startIndex = _endIndex;
        _endIndex =
            (_endIndex + _seatsPerPage) > _seats[_selectedTicketType]!.length
                ? _seats[_selectedTicketType]!.length
                : _endIndex + _seatsPerPage;
      }
    });
  }

// Fungsi untuk memuat kursi sebelumnya
  void _loadPreviousSeats() {
    setState(() {
      if (_startIndex > 0) {
        _endIndex = _startIndex;
        _startIndex =
            (_startIndex - _seatsPerPage) < 0 ? 0 : _startIndex - _seatsPerPage;
      }
    });
  }

  int _ticketPrice = 0;

  late DocumentSnapshot ticketDoc; // Ticket document snapshot
  late String _paymentMethod = ''; // Stores the selected payment method
  late String _paymentDetails =
      ''; // Stores the payment details (account number/phone)

  int get _totalPrice {
    Map<String, int> ticketPrices = {
      'VVIP': 100000,
      'VIP': 75000,
      'TRIBUN': 50000,
    };
    return ticketPrices[_selectedTicketType]! * _selectedSeats.length;
  }

  void _onSeatSelect(String seat) {
    if (_bookedSeats.contains(seat) || _verifiedSeats.contains(seat)) {
      return; // Do not allow selecting booked or verifying seats
    }

    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
      } else {
        if (_selectedSeats.length < 5) {
          _selectedSeats.add(seat);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("1 akun hanya dibatasi 5 tiket"),
              backgroundColor: Colors.red[400],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
            ),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTicketData();
  }

  Future<void> _fetchTicketData() async {
    try {
      DocumentSnapshot ticketSnapshot = await FirebaseFirestore.instance
          .collection('ticket')
          .doc(widget.docId1)
          .get();

      if (ticketSnapshot.exists) {
        setState(() {
          ticketDoc = ticketSnapshot;
          _updateTicketPrice();
        });
      } else {
        print("Ticket data not found in Firestore");
      }
    } catch (e) {
      print("Error fetching ticket data: $e");
    }
  }

  void _updateTicketPrice() {
    switch (_selectedTicketType) {
      case 'VVIP':
        _ticketPrice = 320000;
        break;
      case 'VIP':
        _ticketPrice = 200000;
        break;
      case 'TRIBUN':
        _ticketPrice = 100000;
        break;
      default:
        _ticketPrice = 0;
    }
  }

  int? _parsePrice(String price) {
    try {
      String sanitizedPrice = price.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(sanitizedPrice)?.toInt();
    } catch (e) {
      print("Error parsing price: $e");
      return null;
    }
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
    // Pastikan semua data terisi dengan benar sebelum menyimpan
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedSeats.isEmpty ||
        _selectedTicketType.isEmpty) {
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

    setState(() {
      _verifiedSeats.addAll(_selectedSeats);
      _selectedSeats.clear(); // Clear selected seats after payment step
    });

    // Simulasi proses verifikasi admin
    try {
      // 1. Pertama, ubah status kursi menjadi 'verifying' di Firestore
      for (String seat in _verifiedSeats) {
        await FirebaseFirestore.instance.collection('seats').doc(seat).set({
          'status': 'verifying', // Status kursi menjadi 'verifying'
        }, SetOptions(merge: true)); // Merge untuk tidak menimpa data lain
      }

      // 2. Simpan data transaksi di Firebase
      Map<String, dynamic> transactionData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'total_price': _totalPrice,
        'payment_method': _paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
        'ticket_data': _verifiedSeats.toList(),
        'jenis_ticket': _selectedTicketType,
        'user_id': FirebaseAuth.instance.currentUser?.uid,
      };

      // Simpan data transaksi ke Firestore
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

      // Navigasi ke halaman tiket
      Get.toNamed(Routes.TICKET);
    } catch (e) {
      print("Error during verification or Firebase update: $e");

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

  // Fungsi untuk upload bukti pembayaran ke Firebase Storage
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

  // Fungsi untuk mengubah jenis tiket dan mereset indeks
  void _onTicketTypeChanged(String newTicketType) {
    setState(() {
      _selectedTicketType = newTicketType;
      // Reset indeks saat jenis tiket berubah
      _startIndex = 0;
      _endIndex = _seatsPerPage; // Set _endIndex sesuai dengan _seatsPerPage
    });
  }

  Widget _buildSeatGrid() {
    // Ambil rentang kursi yang akan ditampilkan berdasarkan startIndex dan endIndex
    final seatsToShow =
        _seats[_selectedTicketType]!.sublist(_startIndex, _endIndex);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: seatsToShow.length,
      itemBuilder: (context, index) {
        final seat = seatsToShow[index];

        // Gunakan StreamBuilder untuk mendengarkan status kursi, jika kursi sudah ada di Firestore
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('seats')
              .doc(seat) // Gunakan ID kursi untuk mendengarkan statusnya
              .snapshots(), // Mendapatkan update real-time
          builder: (context, snapshot) {
            // Menunggu status kursi, tampilkan loading jika belum selesai
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Jika ada error
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Ambil data status kursi yang sudah didapat
            if (!snapshot.hasData || !snapshot.data!.exists) {
              // Jika kursi tidak ditemukan di Firestore, anggap statusnya 'available' (hijau)
              return _buildSeatContainer(seat, 'available');
            }

            String seatStatus = snapshot.data!['status'] ?? 'available';

            // Tentukan warna berdasarkan status
            return _buildSeatContainer(seat, seatStatus);
          },
        );
      },
    );
  }

  // Widget untuk menampilkan kursi dengan status yang diberikan
  Widget _buildSeatContainer(String seat, String seatStatus) {
    Color seatColor;

    // Tentukan warna berdasarkan status
    if (seatStatus == 'booked') {
      seatColor = Colors.red;
    } else if (seatStatus == 'verifying') {
      seatColor = Colors.grey; // Warna abu-abu untuk status verifying
    } else {
      seatColor = _selectedSeats.contains(seat)
          ? Colors.blue
          : Colors.green; // Hijau jika belum dipilih
    }

    return GestureDetector(
      onTap: seatStatus == 'booked' || seatStatus == 'verifying'
          ? null // Tidak bisa diklik jika statusnya 'booked' atau 'verifying'
          : () => _onSeatSelect(seat), // Fungsi untuk memilih kursi
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chair,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              seat,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Fungsi untuk mengambil status kursi dari Firebase
  Future<String> _getSeatStatusFromFirebase(String seat) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('seats').doc(seat).get();

    if (snapshot.exists) {
      return snapshot.data()?['status'] ?? 'available'; // Default "available"
    } else {
      return 'available';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisSize: MainAxisSize
                .min, // This will make the Column take as much space as it needs.
            children: [
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
              _buildSectionTitle(
                  'Detail Tiket', Icons.confirmation_number_outlined),
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
                    _buildTicketDetailRow(
                      'Jenis Tiket',
                      _selectedTicketType,
                      Icons.confirmation_number_outlined,
                    ),
                    DropdownButton<String>(
                      value: _selectedTicketType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTicketType = newValue!;
                          _selectedSeat = null; // Reset pilihan kursi
                          _startIndex = 0; // Reset start index ke 0
                          _endIndex =
                              _seatsPerPage; // Reset end index ke 50 (halaman pertama)
                          _updateTicketPrice(); // Update harga tiket
                        });
                      },
                      items: _ticketTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 16),
                    _buildTicketDetailRow(
                      'Harga Tiket',
                      'Rp $_ticketPrice,00',
                      Icons.local_offer_outlined,
                    ),
                    SizedBox(height: 16),
                    Text('Pilih Kursi (${_selectedTicketType})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 16),
                    _buildSeatGrid(),
                    SizedBox(height: 8),
                    // Tombol untuk memuat kursi berikutnya
                    if (_endIndex < _seats[_selectedTicketType]!.length)
                      Center(
                        child: ElevatedButton(
                          onPressed: _loadNextSeats,
                          child: Text('Tampilkan Kursi Selanjutnya'),
                        ),
                      ),
                    // Tombol untuk memuat kursi sebelumnya
                    if (_startIndex > 0)
                      Center(
                        child: ElevatedButton(
                          onPressed: _loadPreviousSeats,
                          child: Text('Tampilkan Kursi Sebelumnya'),
                        ),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _selectedSeat != null
                          ? () {
                              setState(() {
                                _bookedSeats.add(_selectedSeat!);
                                _selectedSeat = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Kursi berhasil dipesan!')),
                              );
                            }
                          : null,
                      child: Text('Pesan Tiket'),
                    ),
                    _buildTicketDetailRow(
                      'Total Harga',
                      'Rp ${_totalPrice.toString()},00',
                      Icons.payment_outlined,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              // Metode Pembayaran Dropdown (Box for payment method)
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
                      onChanged: (String? newMethod) {
                        setState(() {
                          _paymentMethod = newMethod!;
                          _updatePaymentDetails(newMethod);
                        });
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
                      Text(_paymentDetails,
                          style: TextStyle(
                              fontSize: 16)), // Display the payment details
                    ],
                  ],
                ),
              ),
              SizedBox(height: 32),
              // **Bagian Baru** untuk bukti pembayaran
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
                    // Tombol untuk memilih gambar bukti pembayaran
                    ElevatedButton.icon(
                        onPressed: _pickImage, // Fungsi untuk memilih gambar
                        icon: Icon(Icons.photo),
                        label: Text('Pilih Bukti Pembayaran Gambar'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          backgroundColor: Colors
                              .blue, // Mengubah latar belakang tombol menjadi biru muda
                          foregroundColor: Colors
                              .white, // Mengubah warna teks tombol menjadi putih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),

                    SizedBox(height: 16),

                    // Preview gambar yang dipilih
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
                  onPressed:
                      _saveTicketData, // Fungsi yang dipanggil saat tombol ditekan
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    backgroundColor: Colors.blue, // Latar belakang biru muda
                    foregroundColor: Colors.white, // Teks berwarna putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Membuat sudut tombol melengkung
                    ),
                  ),
                  child: Text(
                    'Lanjutkan Pembayaran',
                    style: TextStyle(fontSize: 16), // Ukuran teks
                  ),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF2D3250)),
        SizedBox(width: 8),
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      String hintText, IconData icon,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Color(0xFF2D3250)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF2D3250), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        filled: true,
        fillColor: Color(0xFFF5F5F7),
      ),
    );
  }

  Widget _buildTicketDetailRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF2D3250), size: 20),
            SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
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
}
