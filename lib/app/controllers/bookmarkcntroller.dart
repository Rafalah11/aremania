import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  // Menyimpan status bookmark untuk setiap artikel dengan ID-nya
  var bookmarkStatus = <String, bool>{}.obs;

  // Memeriksa status bookmark dari Firestore
  Future<void> checkBookmarkStatus(String articleId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(articleId)
        .get();

    // Update status bookmark berdasarkan hasil query dari Firestore
    if (docSnapshot.exists) {
      bookmarkStatus[articleId] = true;
    } else {
      bookmarkStatus[articleId] = false;
    }
  }

  // Fungsi untuk toggle status bookmark
  void toggleBookmark(
      String articleId, Map<String, dynamic> articleData) async {
    final isBookmarked = bookmarkStatus[articleId] ?? false;

    if (isBookmarked) {
      // Jika sudah di-bookmark, hapus bookmark
      bookmarkStatus[articleId] = false;
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .delete();
    } else {
      // Jika belum di-bookmark, tambahkan bookmark
      bookmarkStatus[articleId] = true;
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .set(articleData); // Hanya satu entri bookmark yang akan disimpan
    }
  }
}
