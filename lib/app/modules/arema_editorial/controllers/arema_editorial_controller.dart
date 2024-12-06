import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AremaEditorialController extends GetxController {
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

  void toggleBookmark(QueryDocumentSnapshot article) {
    final articleId = article.id;

    if (bookmarkStatus[articleId] == true) {
      // If already bookmarked, remove bookmark
      bookmarkStatus[articleId] = false;
      // Remove from Firestore (if applicable)
      FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .delete();
    } else {
      // If not bookmarked, add bookmark
      bookmarkStatus[articleId] = true;
      // Add to Firestore (if applicable)
      FirebaseFirestore.instance.collection('bookmarks').doc(articleId).set({
        'judul_artikel': article['judul_artikel'],
        'gambar_url': article['gambar_url'],
        'gambar2_url': article['gambar2_url'],
        'id_artikel': article['id_artikel'],
        'isi_artikel': article['isi_artikel'],
        'kategori': article['kategori'],
        'nama_upload': article['nama_upload'],
        'sub_kategori': article['sub_kategori'],
        'tanggal_upload': article['tanggal_upload'],
        // Add other relevant fields as needed
      });
    }
  }
}
