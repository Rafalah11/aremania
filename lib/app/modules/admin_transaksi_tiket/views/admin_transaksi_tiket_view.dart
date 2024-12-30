import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminTransaksiTiketView extends StatefulWidget {
  const AdminTransaksiTiketView({super.key});

  @override
  _AdminTransaksiTiketViewState createState() =>
      _AdminTransaksiTiketViewState();
}

class _AdminTransaksiTiketViewState extends State<AdminTransaksiTiketView> {
  String searchQuery = ''; // Menyimpan query pencarian
  List<QueryDocumentSnapshot> filteredTransaksiList =
      []; // Daftar transaksi yang sudah difilter

  // Fungsi untuk memfilter transaksi berdasarkan query pencarian
  List<QueryDocumentSnapshot> filterTransaksi(
      List<QueryDocumentSnapshot> transaksiList) {
    if (searchQuery.isEmpty) {
      return transaksiList; // Kembalikan semua data jika tidak ada pencarian
    } else {
      return transaksiList.where((transaksi) {
        String name = transaksi['name'].toString().toLowerCase();
        String email = transaksi['email'].toString().toLowerCase();
        String id = transaksi.id.toLowerCase();

        // Pencarian berdasarkan input pada name, email, dan id transaksi
        return name.contains(searchQuery.toLowerCase()) ||
            email.contains(searchQuery.toLowerCase()) ||
            id.contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Tiket'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kolom pencarian
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Cari transaksi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // StreamBuilder untuk menampilkan data tiket
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada transaksi tiket tersedia.',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  final transaksiList = snapshot.data!.docs;
                  // Mengambil data yang sudah difilter
                  filteredTransaksiList = filterTransaksi(transaksiList);

                  return ListView.builder(
                    itemCount: filteredTransaksiList.length,
                    itemBuilder: (context, index) {
                      var transaksi = filteredTransaksiList[index];
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
                                  GestureDetector(
                                    onTap: () => _showImageDialog(
                                      context,
                                      transaksi['payment_proof'],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        transaksi['payment_proof'],
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Email: ${transaksi['email']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Name: ${transaksi['name']}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Payment Method: ${transaksi['payment_method']}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Jenis Tiket: ${transaksi['jenis_ticket']}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text('Phone: ${transaksi['phone']}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Ticket Data:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  if (transaksi['ticket_data'] != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          (transaksi['ticket_data'] as Map)
                                              .entries
                                              .map((entry) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              (entry.value as List).map((item) {
                                            return Text(
                                              '${entry.key}: ID: ${item['id']}, Harga: ${item['harga']}, Status: ${item['status']}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            );
                                          }).toList(),
                                        );
                                      }).toList(),
                                    )
                                  else
                                    const Text('Tidak ada data tiket'),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tanggal: ${DateFormat('dd-MM-yyyy').format(transaksi['timestamp']?.toDate() ?? DateTime.now())}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Waktu: ${DateFormat('HH:mm:ss').format(transaksi['timestamp']?.toDate() ?? DateTime.now())}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Total Price: ${transaksi['total_price'] ?? 0}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    'ID Transaksi: ${transaksi.id}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(imageUrl, fit: BoxFit.contain),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Menutup dialog
                  },
                  child: const Text('TUTUP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                Navigator.of(context).pop(); // Menutup dialog (Kembali)
              },
              child: const Text('KEMBALI'),
            ),
            TextButton(
              onPressed: () async {
                // Tidak setuju, mengubah status kursi menjadi "Available"
                await _updateTicketStatus(transaksi, 'Available');
                Navigator.of(context).pop(); // Menutup dialog (Tidak Setuju)
              },
              child: const Text('TIDAK SETUJU'),
            ),
            TextButton(
              onPressed: () async {
                // Setuju, mengubah status kursi menjadi "Booked" dan memindahkan transaksi
                await _updateTicketStatus(transaksi, 'Booked');
                await _moveToValidCollection(transaksi);
                await FirebaseFirestore.instance
                    .collection('transactions')
                    .doc(transaksi.id)
                    .delete();
                Navigator.of(context).pop(); // Menutup dialog (Setuju)
              },
              child: const Text('SETUJU'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTicketStatus(var transaksi, String status) async {
    // Loop melalui setiap jenis tiket yang ada di transaksi
    for (var jenisTiket in transaksi['ticket_data'].keys) {
      // Loop setiap kursi di dalam jenis tiket
      for (var ticket in transaksi['ticket_data'][jenisTiket]) {
        var ticketId = ticket['id']; // ID kursi yang dipilih user

        // Ambil data dari koleksi 'ticket'
        var ticketRef =
            await FirebaseFirestore.instance.collection('ticket').get();

        bool found = false;

        for (var ticketDoc in ticketRef.docs) {
          var ticketData = ticketDoc.data() as Map<String, dynamic>;

          // Cari jenis_tiket yang sesuai
          for (var jenis in ticketData['jenis_tiket']) {
            if (jenis.containsKey(jenisTiket)) {
              // Cari kursi dengan ID yang cocok
              var kursiList = jenis[jenisTiket];
              var kursi = kursiList.firstWhere(
                (kursus) => kursus['id'] == ticketId,
                orElse: () => null,
              );

              if (kursi != null) {
                // Update status kursi menjadi 'Booked'
                kursi['status'] = status;
                found = true;

                // Simpan perubahan ke Firestore
                await ticketDoc.reference.update({
                  'jenis_tiket': ticketData['jenis_tiket'],
                });

                print(
                    'Status kursi dengan ID $ticketId berhasil diperbarui menjadi $status.');
                break;
              }
            }
          }

          if (found) break;
        }

        if (!found) {
          print(
              "Kursi dengan ID $ticketId tidak ditemukan di koleksi 'ticket'.");
        }
      }
    }
  }

  Future<void> _moveToValidCollection(var transaksi) async {
    try {
      // Tambahkan data ke koleksi transaksi_ticket_valid
      await FirebaseFirestore.instance.collection('transaksi_ticket_valid').add(
            transaksi
                .data(), // Menggunakan .data() untuk mengambil seluruh data
          );
      print("Data successfully added to transaksi_ticket_valid collection.");

      // Tambahkan data ke koleksi history_ticket
      await FirebaseFirestore.instance.collection('history_ticket').add(
            transaksi
                .data(), // Menggunakan .data() untuk mengambil seluruh data
          );
      print("Data successfully added to history_ticket collection.");
    } catch (e) {
      print("Error while moving data: $e");
    }
  }
}
