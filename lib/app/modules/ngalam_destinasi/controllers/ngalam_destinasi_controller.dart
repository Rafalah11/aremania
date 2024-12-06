import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NgalamDestinasiController extends GetxController {
  // Using RxMap to observe changes to bookmark status
  var bookmarkStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial bookmark states
    loadBookmarkStatus();
  }

  void loadBookmarkStatus() async {
    // Example to load bookmark status from Firestore or local storage
    // Here, you would fetch saved bookmarks and update bookmarkStatus
    var querySnapshot =
        await FirebaseFirestore.instance.collection('bookmarks').get();

    for (var doc in querySnapshot.docs) {
      bookmarkStatus[doc.id] = true; // Assuming all docs are bookmarked
    }
  }

void toggleBookmark(String articleId) async {
  if (bookmarkStatus[articleId] == true) {
    // Hapus bookmark
    bookmarkStatus[articleId] = false;
    await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(articleId)
        .delete();
  } else {
    // Tambah bookmark
    bookmarkStatus[articleId] = true;
    var articleSnapshot = await FirebaseFirestore.instance
        .collection('Informasi')
        .doc(articleId)
        .get();
    if (articleSnapshot.exists) {
      FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .set(articleSnapshot.data()!);
    }
  }
  
  // Update state secara eksplisit
  bookmarkStatus.refresh();
}

}
