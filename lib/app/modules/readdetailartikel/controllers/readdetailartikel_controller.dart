import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ReaddetailartikelController extends GetxController {
  var bookmarkStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial bookmark states
    loadBookmarkStatus();
  }

  void loadBookmarkStatus() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Pastikan pengguna sudah login

    try {
      // Ambil data bookmarks berdasarkan UID pengguna
      var bookmarksSnapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(currentUser.uid)
          .collection('userBookmarks')
          .get();

      bookmarkStatus.clear(); // Kosongkan status yang ada
      for (var doc in bookmarksSnapshot.docs) {
        bookmarkStatus[doc.id] = true; // Set status bookmark
      }
    } catch (e) {
      print('Error loading bookmark status: $e');
    }
  }

  void toggleBookmark(String articleId) async {
    // Check if user is logged in
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // If not logged in, navigate to login page
      Get.toNamed(Routes.LOGIN);
      return;
    }

    // Proceed with bookmark process
    try {
      if (bookmarkStatus[articleId] == true) {
        // Change bookmark status to false and delete from bookmarks
        bookmarkStatus[articleId] = false;
        await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(currentUser.uid)
            .collection('userBookmarks')
            .doc(articleId)
            .delete();

        // Update status isBookmarked to false in 'Informasi' collection
        await FirebaseFirestore.instance
            .collection('Informasi')
            .doc(articleId)
            .update({'isBookmarked': false});
      } else {
        // Change bookmark status to true and add to bookmarks
        bookmarkStatus[articleId] = true;
        var articleSnapshot = await FirebaseFirestore.instance
            .collection('Home')
            .doc(articleId)
            .get();
        if (articleSnapshot.exists) {
          // Add article data + bookmark status to bookmarks collection
          await FirebaseFirestore.instance
              .collection('bookmarks')
              .doc(currentUser.uid)
              .collection('userBookmarks')
              .doc(articleId)
              .set({
            ...articleSnapshot.data()!,
            'isBookmarked': true,
          });

          // Update status isBookmarked to true in 'Informasi' collection
          await FirebaseFirestore.instance
              .collection('Informasi')
              .doc(articleId)
              .update({'isBookmarked': true});
        }
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      // Handle error appropriately
    }
  }
}
