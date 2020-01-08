import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
// import 'dart:async';
// import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/framework.dart';

class AddAlbumPage extends StatefulWidget {
  String _albumName;
  //creating state for add album page
  @override
  createState() => _AddAlbumPageState();
}

//state class of add album page
class _AddAlbumPageState extends State<AddAlbumPage> {
  @override
  initState() {
    super.initState();
  }
  FirestoreService fs = new FirestoreService();

  //String _error;

  //function for getting image from camera or gallery
  // Future getImage(bool isCamera) async {
  //   File image;
  //   if (isCamera) {
  //     image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   } else {
  //     image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   }
  //   // Directory appDocDir = await getApplicationDocumentsDirectory();
  //   // String appDocPath = appDocDir.path;
  //   // File newImage = await image.copy('$appDocPath/library/image1.png');
  //   setState(() {
  //     _image = image;
  //   });
  // }

  // validateAlbum(){
  //   if(_albumName==null){
  //     setState(() {
  //      _error='Album Name is Empty';
  //     });
  //   }
  //   if(_image==null){
  //     setState(() {
  //      _error='Image is Empty';
  //     });
  //   }
  //   return _error;
  // }

  //function for adding new album to the album list
  addAlbum(BuildContext context, Function func) {
    //var error = validateAlbum();
    //validateAlbum();
    if (widget._albumName != null && widget._albumName != "") {
      Navigator.of(context).pop(true);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Album Added"),
            content: Container(
              height: 50,
              child: Column(
                children: <Widget>[
                  Text("Album ${widget._albumName} is added to your Library"),
                  SizedBox(height: 12),
                  Text('Now Add item to it')
                ],
              ),
            ),
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Library>(
        builder: (context, child, model) => Scaffold(
              appBar: AppBar(
                title: Text('Add Album Page'),
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
                            widget._albumName = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Album Name",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.red),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      width: 200.0,
                    ),
                    widget._albumName != null && widget._albumName != ''
                        ? Text('')
                        : Text(
                            'Please enter album name',
                            textAlign: TextAlign.center,
                          ),
                    SizedBox(height: 50),
                    // Text(
                    //   'Select Image for Album Icon',
                    //   textAlign: TextAlign.center,
                    // ),
                    // SizedBox(height: 10),
                    // RaisedButton.icon(
                    //     label: Text('Take Image from Camera'),
                    //     onPressed: () {
                    //       getImage(true);
                    //     },
                    //     color: Colors.blue,
                    //     textColor: Colors.white,
                    //     icon: Icon(Icons.camera_alt)),
                    // SizedBox(height: 10),
                    // RaisedButton.icon(
                    //   icon: Icon(Icons.perm_media),
                    //   label: Text('Choose from Gallery'),
                    //   onPressed: () {
                    //     getImage(false);
                    //   },
                    //   color: Colors.blue,
                    //   textColor: Colors.white,
                    // ),
                    // _image == null
                    //     ? Container()
                    //     : Image.file(_image, height: 100.0, width: 100.0),
                    // SizedBox(height: 30),
                    // _image != null
                    //     ? Container()
                    //     : Text(
                    //         'Please Select an Image',
                    //         textAlign: TextAlign.center,
                    //       ),
                    RaisedButton(
                      child: Text('Confirm'),
                      onPressed: () {
                        print("Album Name is ${widget._albumName}");
                        if (widget._albumName != null &&
                            widget._albumName != "") {
                           
                            FirestoreService().saveAlbumNew(widget._albumName);
                          addAlbum(
                              context,
                              model.createAlbum(
                                  widget._albumName, "image not found"));
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text("Album Name is Required"),
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
                        Fluttertoast.showToast(
                            msg: "Hello this is album ${model.toJson()}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
    ));
  }
}
