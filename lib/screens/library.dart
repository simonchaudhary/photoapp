import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
import 'package:photo_app_gh/firebase_service/streambuilder.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/framework.dart';
import './items/listbytagitems.dart';
import 'package:responsive_container/responsive_container.dart';

import 'album/editalbum.dart';
import 'items/items.dart';

class LibraryPage extends StatefulWidget {
  @override
  createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  StreamData stream = new StreamData();
  //for navigating to add-album page
  void addAlbumPage(BuildContext context) {
    Navigator.of(context).pushNamed('/addalbum');
  }

  //for navigating to items page
  void itemPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemsPage(album: album),
      ),
    );
  }

  //for navigating to edit album page
  void editAlbumPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlbumPage(album: album),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Library>(
        builder: (context, child, model) => WillPopScope(
              child: Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  title: Text("data"),
                  // Text('${model.libraryName}'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: TagSearch(model),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: Text("Warning!!"),
                              content: Text("Do you want to logout?"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/login',
                                            (Route<dynamic> route) => false);
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
                    ),
                  ],
                ),
                body: 
      //           StreamBuilder(
      // stream: FirestoreService().getAlbumNames(),
      // builder: (BuildContext context, AsyncSnapshot snapshot) {
      //   if ( snapshot.hasError || !snapshot.hasData) return new Text('Loading...');
    
      //   return
      //           ListView.builder(
                
              
      //             itemCount: 2,
      //             //snapshot.data.length,
      //             itemBuilder: (BuildContext context,int index){
      //                Albumname albumname = snapshot.data[index];

                  


      //     return 
       ListView(
                //       shrinkWrap: true,
                         
                    padding: EdgeInsets.all(20.0),
                    
                      children: <Widget>[
                       //   Text(albumname.albumname),


                        RaisedButton(
                            child: Text('See Modified Albums'),
                            onPressed: () {
                              model.getModifiedAlbum();
                            }),
                        RaisedButton(
                            child: Text('Write File'),
                            onPressed: () {
                              String library1Json = model.toJson().toString();
                              model.writeSeedFile(library1Json);
                              print('File is written');
                            }),

                                       StreamBuilder(
      stream: FirestoreService(). getAlbum(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if ( snapshot.hasError || !snapshot.hasData) return new Text('Loading...');
    
        return
                ListView.builder(
                //  scrollDirection: Axis.vertical,
                shrinkWrap: true,
                  itemCount:snapshot.data.length,
                  //snapshot.data.length,
                  itemBuilder: (BuildContext context,int index){
                    Album album  = snapshot.data[index];
                     model.createAlbum( album.albumName,  album.albumIcon);
                   //  model.albums.add(album);

                  


          return 
          
                        //   // 
                  // ListTile(
                  //   title: Text(album.albumName),
                  // );

                  //  ExpansionTile(
                  //    title: Text(album.isAlbumModified.toString()),
                  //   // subtitle:Text(album.isAlbumModified.toString()),
                           
                  //              leading: Text(album.albumName),
                  //  );
         

                        // Wrap(
                          
                        //   alignment: WrapAlignment.center,
                        //   spacing: 10.0,
                        //   runSpacing: 20.0,
                          
                        
                          
                        //   children:

                          


                         
                        // //   // model.albums.length == 0
                        // //   //     ? 
                        //   snapshot.hasData
                        //   ?
                               
                               
                              //  model.albums
                              //      .map((album) =>
                            
                                  
                                  ExpansionTile(
                                   
                                     leading: Text(  snapshot.data[index].albumName),
                                       // children:snapshot.data.documents.map(())
                                        key: Key(  model.albums[index].albumName),
                                        title:   model.albums[index].albumIcon is File
                                            ? Image.file(
                                                 snapshot.data[index].albumIcon,
                                                height: 150.0,
                                                width: 150.0,
                                              )
                                            : Text(  model.albums[index].albumIcon.toString()),
                                        // leading :snapshot.data.documents.map((document){
                                        //   return Text(document["albumName"]);
                                        // }),
                                      
                                        
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              RaisedButton(
                                                child: Text('View Album'),
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  itemPage(context, model.albums[model.albums.indexWhere((album)=>album.albumName==snapshot.data[index].albumName)]);
                                                },
                                              ),
                                              RaisedButton(
                                                child: Text('Edit Album'),
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  editAlbumPage(context, model.albums[index]);
                                                },
                                              )
                                            ],
                                          ),
                                        ],
                                      );
    

                        //           ).toList()
                                 
                        //       : [
                        //           Column(
                        //             children: <Widget>[
                        //               SizedBox(height: 30.0),
                        //               Text('Library is Empty'),
                        //               SizedBox(height: 15.0),
                        //               Text(
                        //                   'Please press below button for adding new album'),
                        //               SizedBox(height: 15.0),
                        //               Icon(Icons.arrow_downward),
                        //             ],
                        //           )
                        //         ],
                        // );

                                            },
                                      );
      }
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                           
                            addAlbumPage(context);
                          },
                        ),
                      ],
                     )
            
          
      //             },
      //           );
        
      // }
      //          ),
              ),
              onWillPop: () async => false,
            ));
  }
}

class TagSearch extends SearchDelegate<Library> {
  final Library mylib;
  TagSearch(this.mylib);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  showItems(BuildContext context, List<Item> items, String tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListByTagItems(items: items, tag: tag),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ScopedModelDescendant<Library>(
      builder: (context, child, model) => Column(children: <Widget>[
            Text('Here is the list of album containing $query'),
            SizedBox(height: 20.0),
            ResponsiveContainer(
              heightPercent: 80,
              widthPercent: 100,
              child: ListView(
                  children: mylib.albums != null && mylib.albums.length != 0
                      ? mylib.albums
                          .map((album) => Column(
                                children: <Widget>[
                                  album.getItemByTagAlbum(query) == true
                                      ? GestureDetector(
                                          onTap: () {
                                            showItems(
                                                context, album.items, query);
                                          },
                                          child: album.albumIcon is File
                                              ? Image.file(
                                                  album.albumIcon,
                                                  height: 200.0,
                                                  width: 200.0,
                                                )
                                              : Container(
                                                  height: 200,
                                                  width: 200,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Album Icon not found'),
                                                  ),
                                                ),
                                        )
                                      : Text(
                                          "Album '${album.albumName}' doesnot contain $query"),
                                  SizedBox(height: 20.0)
                                ],
                              ))
                          .toList()
                      : [Text('nothing here')]),
            )
          ]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }
}
