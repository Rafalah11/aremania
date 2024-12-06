import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NgalamTerbaruController extends GetxController {
  // Using RxMap to observe changes to bookmark status
  var bookmarkStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial bookmark states
    loadBookmarkStatus();
  }

  void reloadBookmarkStatus() async {
    var articlesSnapshot =
        await FirebaseFirestore.instance.collection('Informasi').get();

    for (var doc in articlesSnapshot.docs) {
      bookmarkStatus[doc.id] = doc['isBookmarked'] ?? false;
    }
  }

  void loadBookmarkStatus() async {
    var bookmarksSnapshot =
        await FirebaseFirestore.instance.collection('bookmarks').get();

    // Clear existing status and rebuild from bookmarks collection
    bookmarkStatus.clear();
    for (var doc in bookmarksSnapshot.docs) {
      bookmarkStatus[doc.id] = true;
    }
  }

  void toggleBookmark(String articleId) async {
    if (bookmarkStatus[articleId] == true) {
      // Ubah status bookmark menjadi false dan hapus dari koleksi bookmarks
      bookmarkStatus[articleId] = false;
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .delete();

      // Update status isBookmarked menjadi false di koleksi 'Informasi'
      await FirebaseFirestore.instance
          .collection('Informasi')
          .doc(articleId)
          .update({'isBookmarked': false});
    } else {
      // Ubah status bookmark menjadi true dan tambahkan ke koleksi bookmarks
      bookmarkStatus[articleId] = true;
      var articleSnapshot = await FirebaseFirestore.instance
          .collection('Informasi')
          .doc(articleId)
          .get();
      if (articleSnapshot.exists) {
        // Tambahkan data artikel + status bookmark ke koleksi bookmarks
        FirebaseFirestore.instance.collection('bookmarks').doc(articleId).set({
          ...articleSnapshot.data()!, // Salin semua data dari dokumen asli
          'isBookmarked': true, // Tambahkan status bookmark
        });

        // Update status isBookmarked menjadi true di koleksi 'Informasi'
        await FirebaseFirestore.instance
            .collection('Informasi')
            .doc(articleId)
            .update({'isBookmarked': true});
      }
    }
  }
}
