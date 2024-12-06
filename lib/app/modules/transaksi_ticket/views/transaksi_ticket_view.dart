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
  int _ticketPrice = 0;

  late DocumentSnapshot ticketDoc; // Ticket document snapshot
  late String _paymentMethod = ''; // Stores the selected payment method
  late String _paymentDetails =
      ''; // Stores the payment details (account number/phone)

  int _ticketCount = 1;

  int get _totalPrice => _ticketPrice * _ticketCount;

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
        _ticketPrice = _parsePrice(ticketDoc['harga_vip_utama']) ?? 320000;
        break;
      case 'VIP':
        _ticketPrice =
            _parsePrice(ticketDoc['harga_vip_barat_selatan']) ?? 200000;
        break;
      case 'TRIBUN':
        _ticketPrice =
            _parsePrice(ticketDoc['harga_tribun_timur_utara_selatan']) ??
                100000;
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
    // Validasi input
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
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

    // Ambil data dari ticketDoc
    Map<String, dynamic> ticketData = ticketDoc.data() as Map<String, dynamic>;

    // Ambil user_id dari FirebaseAuth
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Gabungkan data dari form dengan data tiket
    Map<String, dynamic> transactionData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'ticket_count': _ticketCount,
      'total_price': _totalPrice,
      'payment_method': _paymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
      'ticket_data':
          ticketData, // Menyimpan seluruh data tiket dari dokumen sebelumnya
      'jenis_ticket':
          _selectedTicketType, // Menambahkan jenis tiket yang dipilih
      'payment_proof': _paymentProofImage != null
          ? await _uploadPaymentProof(
              _paymentProofImage!) // Upload bukti pembayaran
          : null,
      'user_id': userId, // Menambahkan user_id yang sedang login
    };

    // Simpan data transaksi ke Firestore
    try {
      await FirebaseFirestore.instance
          .collection('transaksi_ticket')
          .add(transactionData);

      // Tampilkan SnackBar sukses
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

      // Kembali langsung ke halaman ticket_view tanpa delay
      Get.toNamed(Routes.TICKET);
    } catch (e) {
      print("Error saving ticket data: $e");
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
                          _updateTicketPrice(); // Update harga tiket setelah memilih jenis tiket
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.grey[200]),
                    ),
                    _buildTicketDetailRow(
                      'Harga Tiket',
                      'Rp ${_ticketPrice.toString()},00',
                      Icons.local_offer_outlined,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.grey[200]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.confirmation_number_outlined,
                                color: Color(0xFF2D3250), size: 20),
                            SizedBox(width: 8),
                            Text('Jumlah Tiket',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _buildCounterButton(
                                Icons.remove,
                                () {
                                  if (_ticketCount > 1) {
                                    setState(() => _ticketCount--);
                                  }
                                },
                              ),
                              Container(
                                width: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  _ticketCount.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _buildCounterButton(
                                Icons.add,
                                () {
                                  setState(() => _ticketCount++);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.grey[200]),
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
