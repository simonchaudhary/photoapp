import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_app_gh/models/framework.dart';

class FirestoreService {
  final db = Firestore.instance;
  String albumName;
  List<Albumname> albums = [];
  Map<String, dynamic> json;

  Stream<List<Albumname>> getAlbumNames() {
    return db.collection('user1').snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (document) => Albumname.returnAlbumName(
                    document.data, document.documentID),
              )
              .toList(),
        );
  }

  Stream<List<Album>> getAlbum() {
    return db
        .collection('user1')
        .document("user1")
        .collection("albums")
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .map(
                (document) => Album().returnAlbum(document.data),
              )
              .toList(),
        );
  }

  Stream<List<Item>> getItems1(String albumName) {
    return db
        .collection('user1')
        .document("user1")
        .collection("albums")
        .document(albumName)
        .collection("items")
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .map(
                (document) => Item.fromJson(document.data),
              )
              .toList(),
        );
  }

  List<Item> getItems() {
    List<Item> itmsss = List();
    db
        .collection('user1')
        .document("user1")
        .collection("albums")
        .document("a")
        .collection("items")
        .snapshots()
        .map((snapshot) {
      snapshot.documents.map(
        (document) {
          itmsss.add(Item.fromJson(document.data));
        },
      );
    });
    return itmsss;
  }

  saveItem(Album album, String url) async {
    await db
        .collection("user1")
        .document("${album.albumName}")
        .collection("${album.albumName}")
        .add(album.toJson(url));
  }

  Future<void> addItemInAlbum(Album album, String url) {
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        // .document("albums")
        // .collection("${album.albumName}")
        .document("${album.albumName}")
        .setData(album.toJson(url));
  }

  Future<void> addItem(Album album, String url) {
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        // .document("albums")
        // .collection("${album.albumName}")
        .document("${album.albumName}")
        .collection("items")
        .document(album.items.last.itemDescr)
        .setData(album.items.last.toJson(url));
  }

  saveAlbum(String albumName) {
    return db
        .collection("user1")
        .document(albumName)
        .setData(toJson(albumName));
  }

  saveAlbumNew(String albumName) {
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        // .document("albums")
        // .collection("${album.albumName}")
        .document(albumName)
        .setData(toJson(albumName));
  }

  Future<void> deleteAlbum(String id) {
    return db.collection("user1").document(id).delete();
  }

  Future<void> editAlbum(Album album, String newAlbumname) {
    return db
        .collection("user1")
        .document(album.id)
        .updateData(toJson(newAlbumname));
  }

  toJson(String albumName) {
    return ({
      'albumName': albumName,
    });
  }

  Future<List<Albumname>> getAlbums() {
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        .getDocuments()
        .then(
          (snapshot) => snapshot.documents
              .map(
                (document) => Albumname.returnAlbumName(
                    document.data, document.documentID),
              )
              .toList(),
        );
  }
}

class Albumname {
  final String albumName;
  dynamic albumIcon;
  List<Item> items;
  bool isAlbumModified = false;
  Item item = Item();
  String id;

  Albumname({
    this.albumName,
    this.albumIcon,
    this.items,
    this.isAlbumModified,
    this.id,
  });
  // final String albumname;
  // final String id;
  // Albumname({this.albumname, this.id});
  Albumname.returnAlbumName(Map<String, dynamic> data, String id)
      : albumName = data["albumName"],
        //  albumIcon = data["albumIcon"];
        id = id;
}

class EditItem {
  final db = Firestore.instance;
  String url;

  Future editItems(String newItemdescription, String oldItemdescription,
      dynamic image, Album album) async {
    print("entered in edit items");
    print("type of image = " + image.runtimeType.toString());

    if (image.runtimeType != String) {
      print("here image == file");
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(album.albumName);
      var timeKey = new DateTime.now();
      StorageUploadTask uploadTask =
          firebaseStorageRef.child(timeKey.toString() + ".jpg").putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      final String imageUrl = (await taskSnapshot.ref.getDownloadURL());

      url = imageUrl.toString();
    } else if (image is String) {
      print("here image == string");
      url = image;
    }

    if (newItemdescription == oldItemdescription) {
      print("newItemdescription ==oldItemdescription");
      editedItem(newItemdescription, oldItemdescription, url, album);
    } else {
      print("deleting old document");
      addItem(newItemdescription, oldItemdescription, url, album);
      deleteDocument(oldItemdescription, album);
    }

    // checknew(newItemdescription , oldItemdescription);

    Fluttertoast.showToast(
        msg: "URL is$url",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  editedItem(String newItemdescription, String oldItemdescription,
      dynamic image, Album album) {
    print("upadating item in old document");
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        .document(album.albumName)
        .collection("items")
        .document(oldItemdescription)
        .updateData({"image": image, "itemDescription": oldItemdescription});
  }

  addItem(String newItemdescription, String oldItemdescription, dynamic image,
      Album album) {
    print("upadating item in old document");
    return db
        .collection("user1")
        .document("user1")
        .collection("albums")
        .document(album.albumName)
        .collection("items")
        .document(newItemdescription)
        .setData({"image": image, "itemDescription": newItemdescription});
  }

  deleteDocument(String oldItemdescription, Album album) {
    db
        .collection("user1")
        .document("user1")
        .collection("albums")
        .document(album.albumName)
        .collection("items")
        .document(oldItemdescription)
        .delete();
  }

  checknew(String newItemdescription, String oldItemdescription) {
    if (newItemdescription == oldItemdescription) {
      print("newItemdescription ==oldItemdescription");
      //editedItem( newItemdescription, oldItemdescription, url, album);
    } else {
      print("deleting old document");
      //   editedItem( newItemdescription, oldItemdescription, url, album);

    }
  }
}
