import 'package:flutter/material.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
import 'package:photo_app_gh/res/colors.dart';
import '../../models/framework.dart';
import 'package:image_picker/image_picker.dart';

class EditItemPage extends StatefulWidget {
  final Item item;
  final Album album;
  EditItemPage({Key key, this.item, this.album}) : super(key: key);
  @override
  createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  int refresh = 0;
  List<String> _newTags;
  bool _changeImage = false;
  String _newItemDescription;
  String textTag;
  //File _image;
  dynamic _image;
  List<String> _finalTags;

  removeTag(String tag) {
    setState(() {
      refresh = 1;
    });
    widget.item.itemTags.remove(tag);
  }

  addTag(String tag) {
    print("tag");
    setState(() {
      _newTags.add(tag);
      refresh = 1;
    });
    print(_newTags);
  }

  //function for getting image from camera or gallery
  Future getImage(bool isCamera) async {
    //File image;
    dynamic image;
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

  editItem(BuildContext context, Function func) {
    Navigator.of(context).pop(true);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Item Edited"),
          content: Text("New Item's Description is $_newItemDescription"),
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

  _showDialog() {
    _newTags = List<String>();
    //final TextEditingController _tagController = new TextEditingController();
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
                  //controller: _tagController,
                  autofocus: false,
                  autocorrect: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      textTag = value;
                    });

                    //_tagController.clear();
                  },
                  // onSubmitted: (value) {
                  //   setState(() {
                  //     print(value);
                  //     textTag = value;
                  //   });

                  //   //_tagController.clear();
                  // },
                  decoration: InputDecoration(
                    hintText: "Enter Tag Here",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400, ),
                    border: OutlineInputBorder(),
                  )),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
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
                  child: Text("Done"),
                  onPressed: () {
                    print("done");
                    if (textTag == null) {
                      print("field is empty");
                    } else {
                      setState(() {
                        addTag(textTag);
                      });
                    }

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

  removeThisItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Warning"),
          content: Text("Do you want to remove this item?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                print("item descripion of removing item = " +
                    widget.item.itemDescr);
                print("albumname of removing item = " + widget.album.albumName);
                EditItem().deleteDocument(widget.item.itemDescr, widget.album);
                widget.album.items.remove(widget.item);
                Navigator.of(context).pushNamed('/library');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Container(
        //color: Colors.red,
        padding: const EdgeInsets.all(4.0),
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Text(
              widget.item.itemDescr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              decoration: BoxDecoration(
                color: black88,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                // autocorrect: true,
                //autofocus: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Please Type New Item Description',
                ),
                onChanged: (value) {
                  setState(() {
                    _newItemDescription = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _image == null
                    ?
                    // Image.file(widget.item.itemImage,
                    Image.network(widget.item.itemImage,
                        height: 150.0, width: 150.0)
                    : Image.file(_image, height: 150.0, width: 150.0),
                _changeImage
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text(
                              'Choose from Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              getImage(false);
                              //for change button
                              setState(() {
                                _changeImage = false;
                              });
                            },
                          ),
                          RaisedButton(
                            child: Text(
                              'Choose from Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              getImage(true);
                              //for change button
                              setState(() {
                                _changeImage = false;
                              });
                            },
                          )
                        ],
                      )
                    : RaisedButton(
                        child: Text(
                          'Change Image',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _changeImage = true;
                          });
                        },
                        color: Colors.blue,
                      )
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10.0),
            Text(
              'Old Tags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.0),
            Wrap(
                children: widget.item.itemTags != null &&
                        widget.item.itemTags.length != 0
                    ? widget.item.itemTags
                        .map((itemTag) => Stack(
                              children: <Widget>[
                                FilterChip(
                                  label: Text(itemTag),
                                  onSelected: (bool value) {
                                    print("selected");
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.cancel),
                                  onTap: () {
                                    removeTag(itemTag);
                                  },
                                )
                              ],
                            ))
                        .toList()
                    : [Text('No Tags')]),
            SizedBox(height: 10),
            Text(
              'New Tags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.0),
            Wrap(
                spacing: 10.0,
                children: _newTags != null && _newTags.length != 0
                    ? _newTags
                        .map((itemTag) => Stack(
                              children: <Widget>[
                                FilterChip(
                                  label: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(itemTag)),
                                  onSelected: (bool value) {
                                    print("selected");
                                  },
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.redAccent,
                                    size: 20.0,
                                  ),
                                  onTap: () {
                                    _newTags.remove(itemTag);
                                    setState(() {
                                      refresh = 1;
                                    });
                                  },
                                )
                              ],
                            ))
                        .toList()
                    : [Text('New Tag is empty')]),
            FloatingActionButton(
              child: Icon(Icons.tag_faces),
              onPressed: () {
                _showDialog();
              },
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (_newTags != null && widget.item.itemTags == null) {
                  _finalTags = _newTags;
                } else if (_newTags == null && widget.item.itemTags == null) {
                  _finalTags = [''];
                } else if (_newTags == null && widget.item.itemTags != null) {
                  _finalTags = widget.item.itemTags;
                } else if (_newTags != null && widget.item.itemTags != null) {
                  _finalTags = List.from(widget.item.itemTags)
                    ..addAll(_newTags);
                }
                print(_finalTags);
                print('hello');
                if (_image != null && _newItemDescription == null) {
                  print('image xa name xaina');
                  print(widget.album.albumName);
                  EditItem().editItems(widget.item.itemDescr,
                      widget.item.itemDescr, _image, widget.album);
                  print("item discription = " + widget.item.itemDescr);
                  print(_image.runtimeType);
                  editItem(
                      context,
                      widget.item
                          .editItem(widget.item.itemDescr, _image, _finalTags));
                } else if (_image == null && _newItemDescription != null) {
                  print('image xaina name xa');
                  print(widget.item.itemImage.toString());
                  EditItem().editItems(
                      _newItemDescription,
                      widget.item.itemDescr,
                      widget.item.itemImage.toString(),
                      widget.album);
                  print("the new itemDescription = " + _newItemDescription);

                  editItem(
                      context,
                      widget.item.editItem(_newItemDescription,
                          widget.item.itemImage, _finalTags));
                } else if (_image != null && _newItemDescription != null) {
                  print('image xa name xa');
                  EditItem().editItems(_newItemDescription,
                      widget.item.itemDescr, _image, widget.album);
                  print("new item description  = " + _newItemDescription);
                  editItem(
                      context,
                      widget.item
                          .editItem(_newItemDescription, _image, _finalTags));
                }else if(_newTags !=null){
                  

                } 
                else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: Text("Warning"),
                        content: Text('Please change something'),
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
            ),
            RaisedButton(
              onPressed: () {
                removeThisItem(context);
              },
              child: Text(
                'Remove this Item',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
