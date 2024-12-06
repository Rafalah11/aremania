import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketSayaController extends GetxController {
  var email = ''.obs;
  var jenisTicket = ''.obs;
  var idDokumen = ''.obs;
  var totalPrice = ''.obs;
  var ticketCount = ''.obs;
  var isTicketPurchased =
      false.obs; // Menambahkan flag untuk mengecek apakah tiket sudah dibeli

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1), () {
      fetchTicketData(); // Cek setelah sedikit delay
    });
  }

  Future<void> fetchTicketData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        print("User is not logged in.");
        return;
      }

      var querySnapshot = await FirebaseFirestore.instance
          .collection('transaksi_ticket_valid')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var ticketData = querySnapshot.docs.first;
        // Set the ticket data
        email.value = ticketData['email'];
        jenisTicket.value = ticketData['jenis_ticket'];
        idDokumen.value = ticketData.id; // ID dokumen sebagai kode tiket
        totalPrice.value = ticketData['total_price'].toString();
        ticketCount.value = ticketData['ticket_count'].toString();

        // Update isTicketPurchased to true
        isTicketPurchased.value = true;
      } else {
        isTicketPurchased.value = false; // Jika tidak ada tiket
      }
    } catch (e) {
      print('Error fetching ticket data: $e');
    }
  }
}
