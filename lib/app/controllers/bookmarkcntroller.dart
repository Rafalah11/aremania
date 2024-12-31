import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class BookmarkController extends GetxController {
  var bookmarkStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarkStatus();
  }

  void loadBookmarkStatus() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      var bookmarksSnapshot = await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(currentUser.uid)
          .collection('userBookmarks')
          .get();

      bookmarkStatus.clear();
      for (var doc in bookmarksSnapshot.docs) {
        bookmarkStatus[doc.id] = true;
      }
    } catch (e) {
      print('Error loading bookmark status: $e');
    }
  }

  void toggleBookmark(String articleId) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    try {
      if (bookmarkStatus[articleId] == true) {
        bookmarkStatus[articleId] = false;

        await FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(currentUser.uid)
            .collection('userBookmarks')
            .doc(articleId)
            .delete();

        await _updateIsBookmarkedStatus(articleId, false);
      } else {
        bookmarkStatus[articleId] = true;

        var homeSnapshot = await FirebaseFirestore.instance
            .collection('Home')
            .doc(articleId)
            .get();

        if (homeSnapshot.exists) {
          await FirebaseFirestore.instance
              .collection('bookmarks')
              .doc(currentUser.uid)
              .collection('userBookmarks')
              .doc(articleId)
              .set({
            ...homeSnapshot.data()!,
            'isBookmarked': true,
          });
        }

        await _updateIsBookmarkedStatus(articleId, true);
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  Future<void> _updateIsBookmarkedStatus(String articleId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('Home')
          .doc(articleId)
          .update({'isBookmarked': status});
    } catch (e) {
      print('Error updating isBookmarked status: $e');
    }
  }
}
