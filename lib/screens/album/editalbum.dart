import 'package:flutter/material.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/framework.dart';
import 'dart:io';

class EditAlbumPage extends StatefulWidget {
  final Album album;
  EditAlbumPage({Key key, this.album }) : super(key: key);

  @override
  createState() => _EditAlbumPageState();
}

class _EditAlbumPageState extends State<EditAlbumPage> {
  FirestoreService fs = new FirestoreService();

  String _newAlbumName;
  File _newImage;

  editAlbum(BuildContext context, Function func) {
    //var error = validateAlbum();
    //validateAlbum();
    Navigator.of(context).pop(true);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Album Edited"),
          content: _newAlbumName != null && _newAlbumName != ''
              ? Text("New Album Name is $_newAlbumName")
              : Text("${widget.album.albumName}'s Image is Edited"),
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

  showItems() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                'Please Select the Icon for Album',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
                child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  widget.album.items != null && widget.album.items.length != 0
                      ? widget.album.items
                          .map((item) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _newImage = item.itemImage;
                                });
                                Navigator.of(context).pop(true);
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.file(
                                    item.itemImage,
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                                ],
                              )))
                          .toList()
                      : [Text('No Items Found')],
            )),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Done"),
                  onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Library>(
      builder: (context, child, model) => Scaffold(
            appBar: AppBar(
              title: Text("Edit Album"),
            ),
            body: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Text(widget.album.albumName),
                SizedBox(height: 10),
                TextField(
                    autocorrect: true,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Please Type New Album Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _newAlbumName = value;
                      });
                    }),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              child: widget.album.albumIcon is File
                                  ? Image.file(widget.album.albumIcon,
                                      height: 150.0, width: 150.0)
                                  : Container(
                                      height: 150.0,
                                      width: 150.0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(widget.album.albumIcon),
                                      ),
                                    ),
                              onTap: () {
                                setState(() {
                                  _newImage = widget.album.albumIcon;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            Text('Original Image'),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          children: <Widget>[
                            _newImage != null
                                ? Image.file(_newImage,
                                    height: 150.0, width: 150.0)
                                : Image.asset(
                                    'assets/image1.png',
                                    height: 150.0,
                                    width: 150.0,
                                  ),
                            SizedBox(height: 10),
                            Text('New Image'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                RaisedButton.icon(
                    label: Text('Choose from Items'),
                    onPressed: () {
                      showItems();
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    icon: Icon(Icons.arrow_forward_ios)),
                SizedBox(height: 10),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Edit Album'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_newImage != null &&
                        _newAlbumName == null) {
                      print('image xa name xaina');
                      editAlbum(
                          context,
                          widget.album
                              .editAlbum(widget.album.albumName, _newImage));
                    } else if (_newImage == null && _newAlbumName != null) {
                      fs.editAlbum(widget.album,_newAlbumName);

                      print('image xaina name xa');
                      editAlbum(
                          context,
                          widget.album.editAlbum(
                              _newAlbumName, widget.album.albumIcon));
                    } else if (_newImage != null && _newAlbumName != null) {
                       fs.editAlbum(widget.album,_newAlbumName);
                      print('image xa name xa');
                      editAlbum(context,
                          widget.album.editAlbum(_newAlbumName, _newImage));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: Text("Warning"),
                            content: Text('Please add something'),
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
                ),
                widget.album.items.length == 0
                    ? RaisedButton(
                        color: Colors.red,
                        child: Text(
                          'Remove this Album',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Warning"),
                                content:
                                    Text("Do you want to remove this album?"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  FlatButton(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      model.removeAlbum(widget.album);
                                      Navigator.of(context)
                                          .pushNamed('/library');
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
    );
  }
}
