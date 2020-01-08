import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/framework.dart';

class FirestoreServices {
  getItems(Album album) {
    return Firestore.instance
        .collection("user")
        .document("user")
        .collection(album.albumName)
        .document(album.albumName)
        .collection("album")
        .snapshots();
  }
}
