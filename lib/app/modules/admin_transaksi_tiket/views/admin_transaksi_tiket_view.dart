import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTransaksiTiketView extends StatelessWidget {
  const AdminTransaksiTiketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Tiket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(
                  'transaksi_ticket') // Mengambil data dari Firestore collection 'transaksi_ticket'
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('Tidak ada transaksi tiket tersedia.',
                    style: TextStyle(fontSize: 20)),
              );
            }

            final transaksiList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                var transaksi = transaksiList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => _showApprovalDialog(context, transaksi),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ${transaksi['email']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${transaksi['name']}',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text(
                                'Payment Method: ${transaksi['payment_method']}',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('Jenis Tiket: ${transaksi['jenis_ticket']}',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('Phone: ${transaksi['phone']}',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('Ticket Count: ${transaksi['ticket_count']}',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('Total Price: Rp ${transaksi['total_price']}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                                'Timestamp: ${_formatTimestamp(transaksi['timestamp'])}'),
                            const SizedBox(height: 16),
                            if (transaksi['payment_proof'] != null)
                              Image.network(
                                transaksi['payment_proof'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk memformat timestamp
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  // Fungsi untuk menampilkan dialog konfirmasi dan mengirimkan email
  void _showApprovalDialog(BuildContext context, var transaksi) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Transaksi'),
          content: Text(
            'Apakah Anda setuju untuk memproses transaksi ini?\n\n'
            'Nama: ${transaksi['name']}\n'
            'Jenis Tiket: ${transaksi['jenis_ticket']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Menutup dialog
                Navigator.of(context).pop();
              },
              child: const Text('TIDAK'),
            ),
            TextButton(
              onPressed: () async {
                // 1. Pindahkan data transaksi ke koleksi 'transaksi_ticket_valid'
                await _moveToValidCollection(transaksi);

                // 2. Hapus transaksi dari koleksi 'transaksi_ticket'
                await FirebaseFirestore.instance
                    .collection('transaksi_ticket')
                    .doc(transaksi.id)
                    .delete();

                // 3. Generate QR Code
                String qrCodeData = await _generateQRCode(transaksi['email']);

                // 4. Kirim email ke pengguna
                await _sendEmail(
                  transaksi['email'],
                  transaksi['name'],
                  transaksi['jenis_ticket'],
                  qrCodeData,
                );

                // Menutup dialog setelah email dikirim
                Navigator.of(context).pop();

                // Tampilkan notifikasi sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'QR Code berhasil dikirim ke ${transaksi['email']}')),
                );
              },
              child: const Text('SETUJU'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _moveToValidCollection(var transaksi) async {
    try {
      // Ambil UID dari Firebase Auth
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        print("No user is logged in. Cannot add UID.");
        return;
      }

      // Tambahkan UID ke dalam data transaksi yang dipindahkan
      await FirebaseFirestore.instance
          .collection('transaksi_ticket_valid')
          .add({
        'uid': uid, // Menambahkan UID ke dalam data transaksi
        'email': transaksi['email'],
        'name': transaksi['name'],
        'payment_method': transaksi['payment_method'],
        'jenis_ticket': transaksi['jenis_ticket'],
        'phone': transaksi['phone'],
        'ticket_count': transaksi['ticket_count'],
        'total_price': transaksi['total_price'],
        'timestamp': transaksi['timestamp'],
        'payment_proof': transaksi['payment_proof'],
      });

      print("Data successfully moved to transaksi_ticket_valid collection.");
    } catch (e) {
      print("Error while moving data: $e");
    }
  }

  // Fungsi untuk menghasilkan QR Code
  Future<String> _generateQRCode(String data) async {
    String qrData = 'TICKET-${DateTime.now().millisecondsSinceEpoch}-$data';

    // Generate QR Code menggunakan QrImage
    return qrData; // Tidak perlu menampilkan QR Code langsung di sini, hanya mengembalikan data
  }

  // Fungsi untuk mengirimkan email
  Future<void> _sendEmail(
      String email, String name, String ticketType, String qrCodeData) async {
    // Implementasi pengiriman email menggunakan API seperti SendGrid, Mailgun, atau lainnya
    print('Sending email to $email');
    print('Subject: Tiket Transaksi - $name');
    print(
        'Body: Nama: $name\nJenis Tiket: $ticketType\nQR Code Data: $qrCodeData');
    // Implementasikan pengiriman email sesuai dengan API yang Anda pilih
  }
}
