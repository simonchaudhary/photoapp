import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
import 'package:photo_app_gh/screens/album/addalbum.dart';
import '../../models/framework.dart';

class AddItemPage extends StatefulWidget {
  final Album album;
  

  AddItemPage({Key key, this.album}) : super(key: key);
  //creating state for add album page
  @override
  createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String _itemName;
  File _image;
  List<String> _tags;
  String url;
  FirestoreService fs = new FirestoreService();
  String textTag;

  int refresh = 0;
  final databaseReference = Firestore.instance;

  AddAlbumPage addAlbumPage = new AddAlbumPage();

  @override
  void initState() {
    super.initState();
  }

  //function for getting image from camera or gallery
  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    // File newImage = await image.copy('$appDocPath/library/image1.png');
    setState(() {
      _image = image;
    });
  }

  Future uploadPic() async {
    //String fileName = basename(_image.path);
    //String fileName = 'chats/${Path.basename(_image.path)}';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${widget.album.albumName}');

    var timeKey = new DateTime.now();
    StorageUploadTask uploadTask =
        firebaseStorageRef.child(timeKey.toString() + ".jpg").putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String imageUrl = (await taskSnapshot.ref.getDownloadURL());

    url = imageUrl.toString();

   
    //saveToDatabase(url);
    fs.addItemInAlbum(widget.album, url);
    fs.addItem(widget.album, url);
    
                        


   Fluttertoast.showToast(
                    msg: "URL is ${url}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);


    // print('URL Is $url');
    // // setState(() {
    // //   print("Profile Picture uploaded");
    // //   Scaffold.of(context)
    // //       .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    // // });
  }

  Library li = new Library();
  saveToDatabase(url) async {
    var dbTimeKey = new DateTime.now();

    var formatDate = new DateFormat("MMM d, yyyy");
    var formatTime = new DateFormat("EEEE, hh:mm aaa");

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    // DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {"image": url, "date": date, "time": time};


    
    await databaseReference
        .collection("user1")
        .document("${widget.album.albumName}")
        .collection("${widget.album.albumName}")
        .add(widget.album.toJson(url));


    //  await databaseReference
    //     .collection("user1")
    //     .document("${widget.album.albumName}")
    //     .collection("${widget.album.albumName}")
    //     .add(widget.album.toJson(url));
    // await databaseReference
    //     .collection("user")
    //     .document("user")
    //     .collection("${widget.album.albumName}")
    //     .document("${widget.album.albumName}")
    //     .collection("album")
    //     .add(widget.album.toJson(url));
    // await databaseReference
    //     .collection("user")
    //     .document("user")
    //     .collection("${widget.album.albumName}")
    //     .document("${widget.album.albumName}")
    //     .collection("Items")
    //     .add(widget.item.toJson());

    // ref.child("Posts").push().set(data);
  }

  // void getData() {
  //   databaseReference
  //       .collection("${widget.album.albumName}")
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((f) => print('${f.data}}'));
  //   });
  // }

  //function for adding new album to the album list
  addItem(BuildContext context, Function func) {
    //var error = validateAlbum();
    //validateAlbum();
    if (_itemName != null && _itemName != "" && _image != null) {
      Navigator.of(context).pop(true);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Item Added"),
            content: Text("New Item is added to your Album"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      func();
    }
  }

  addTag(String value) {
    print("tag");
    setState(() {
      _tags.add(value);
      refresh = 1;
    });
    print(_tags);
    //widget.album.addItemTag(_tags);
  }

  BuildContext context;
  _showDialog() {
    _tags = List<String>();
    //final TextEditingController _textController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                'Please Select tag or Give your tag',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                 // controller: _textController,
                  autofocus: false,
                  autocorrect: true,
                  textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    setState(() {
                        print(value);
                        textTag = value;
                      });
                    // if (value != null && value != '') {
                    //   //addTag(value);
                    //   //_textController.clear();
                    //   setState(() {
                    //     print(value);
                    //     textTag = value;
                    //   });
                    // }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Tag Here",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.red),
                    border: OutlineInputBorder(),
                  )),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Text('Birthday'),
                    onTap: () {
                      addTag('Wedding');
                    },
                  ),
                  ListTile(
                    title: Text('Graduation'),
                    onTap: () {
                      addTag('Graduation');
                    },
                  ),
                  ListTile(
                    title: Text('Road Trip'),
                    onTap: () {
                      addTag('Road Trip');
                    },
                  ),
                  ListTile(
                    title: Text('Party'),
                    onTap: () {
                      addTag('Party');
                    },
                  ),
                  ListTile(
                    title: Text('Hiking'),
                    onTap: () {
                      addTag('Hiking');
                    },
                  ),
                  ListTile(
                    title: Text('Swimming'),
                    onTap: () {
                      addTag('Swimming');
                    },
                  ),
                  ListTile(
                    title: Text('Dinner'),
                    onTap: () {
                      addTag('Dinner');
                    },
                  ),
                  ListTile(
                    title: Text('Riding'),
                    onTap: () {
                      addTag('Riding');
                    },
                  ),
                  ListTile(
                    title: Text('Camping'),
                    onTap: () {
                      addTag('Camping');
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Dofgsfgse"),
                  onPressed: () {
                    print("dodfdfdne");
                    addTag(textTag);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // ItemsPage album = new ItemsPage();

  //Item it = new Item();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items Page'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              child: TextField(
                autofocus: false,
                autocorrect: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    _itemName = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Item Name",
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
                  border: OutlineInputBorder(),
                ),
              ),
              width: 200.0,
            ),
            _itemName != null && _itemName != ""
                ? Text('')
                : Text(
                    'Please enter item name',
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 25),
            _tags != null
                ? Wrap(
                    children: _tags
                        .map(
                          (item) => FilterChip(
                            label: Text(item),
                            onSelected: (bool value) {
                              print("selected");
                            },
                          ),
                        )
                        .toList())
                : Text(
                    'Tag is empty',
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Select Image for Item Image',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
                label: Text('Take Image from Camera'),
                onPressed: () {
                  getImage(true);
                },
                color: Colors.blue,
                textColor: Colors.white,
                icon: Icon(Icons.camera_alt)),
            SizedBox(height: 10),
            RaisedButton.icon(
              icon: Icon(Icons.perm_media),
              label: Text('Choose from Gallery'),
              onPressed: () {
                getImage(false);
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
            _image == null
                ? Container()
                : Image.file(_image, height: 100.0, width: 100.0),
            SizedBox(height: 30),
            _image != null
                ? Container()
                : Text(
                    'Please Select an Image',
                    textAlign: TextAlign.center,
                  ),
            RaisedButton(
              child: Text('Add Item'),
              onPressed: () {
                uploadPic();
                //getData();
                print('pressed');
                // Fluttertoast.showToast(
                //     msg: "Album Name is ${widget.album.items[0].toJson()}",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.CENTER,
                //     timeInSecForIos: 1,
                //     backgroundColor: Colors.red,
                //     textColor: Colors.white,
                //     fontSize: 16.0);

                if (_itemName != null && _itemName != "" && _image != null) {
                  addItem(
                      context, widget.album.addItem(_itemName, _image, _tags));
                  Navigator.of(context).pop(true);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Item Name and Image is Required"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          FlatButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showDialog();
        },
      ),
    );
  }
}
