import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NgalamReadTerbaruController extends GetxController {
  var bookmarkStatus = false.obs; // Menyimpan status bookmark

  // Fungsi untuk mengecek apakah artikel sudah di-bookmark
  Future<void> checkBookmarkStatus(String articleId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(articleId)
        .get();

    // Jika dokumen ada, berarti artikel sudah di-bookmark
    if (docSnapshot.exists) {
      bookmarkStatus.value = true;
    } else {
      bookmarkStatus.value = false;
    }
  }

  // Fungsi untuk toggle status bookmark
  void toggleBookmark(
      String articleId, Map<String, dynamic> articleData) async {
    if (bookmarkStatus.value) {
      // Jika bookmark sudah ada, hapus dari collection bookmarks
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .delete();
      bookmarkStatus.value = false; // Update status menjadi tidak bookmark
    } else {
      // Jika bookmark belum ada, simpan data artikel ke collection bookmarks
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .set(articleData);
      bookmarkStatus.value = true; // Update status menjadi bookmark
    }
  }
}
