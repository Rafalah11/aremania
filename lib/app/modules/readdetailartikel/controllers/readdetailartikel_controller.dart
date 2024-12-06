import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReaddetailartikelController extends GetxController {
  var bookmarkStatus = <String, bool>{}.obs;
  late StreamSubscription<QuerySnapshot> bookmarkSubscription;
  @override
  void onInit() {
    super.onInit();
    loadBookmarkStatus();
    bookmarkSubscription = FirebaseFirestore.instance
        .collection('bookmarks')
        .snapshots()
        .listen((querySnapshot) {
      for (var doc in querySnapshot.docChanges) {
        if (doc.type == DocumentChangeType.removed) {
          bookmarkStatus.remove(doc.doc.id); // Hapus dari map saat dihapus
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    bookmarkSubscription.cancel();
  }

  void loadBookmarkStatus() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('bookmarks').get();

    for (var doc in querySnapshot.docs) {
      // Asumsikan ada field "isBookmarked" untuk menandai apakah sebuah artikel sudah di-bookmark
      bookmarkStatus[doc.id] = doc.data()["isBookmarked"] ?? false;
    }
  }

  // void toggleBookmark(String articleId) async {
  //   if (bookmarkStatus[articleId] == true) {
  //     // Jika sudah di-bookmark, hapus bookmark
  //     bookmarkStatus[articleId] = false; // Update status di controller
  //     await FirebaseFirestore.instance
  //         .collection('bookmarks')
  //         .doc(articleId)
  //         .delete();
  //   } else {
  //     // Jika belum di-bookmark, tambahkan bookmark
  //     bookmarkStatus[articleId] = true; // Update status di controller
  //     var articleSnapshot = await FirebaseFirestore.instance
  //         .collection('Home')
  //         .doc(articleId)
  //         .get();
  //     if (articleSnapshot.exists) {
  //       FirebaseFirestore.instance
  //           .collection('bookmarks')
  //           .doc(articleId)
  //           .set(articleSnapshot.data()!);
  //     }
  //   }
  // }
  void toggleBookmark(String articleId) async {
    if (bookmarkStatus[articleId] == true) {
      // Jika sudah di-bookmark, hapus bookmark
      bookmarkStatus[articleId] = false; // Update status di controller
      await FirebaseFirestore.instance
          .collection('bookmarks')
          .doc(articleId)
          .delete();
    } else {
      // Jika belum di-bookmark, tambahkan bookmark
      bookmarkStatus[articleId] = true; // Update status di controller
      var articleSnapshot = await FirebaseFirestore.instance
          .collection('Home')
          .doc(articleId)
          .get();
      if (articleSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(articleId)
            .set(articleSnapshot.data()!);
      }
    }

    // Secara eksplisit memicu pembaruan UI dengan menghapus atau menambahkan status
    update(); // Memanggil update untuk memperbarui status reaktif
  }
}
