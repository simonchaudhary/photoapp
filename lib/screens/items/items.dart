
import 'package:flutter/material.dart';
import 'package:photo_app_gh/firebase_service/firebase_service.dart';
import 'package:photo_app_gh/firebaseconnection.dart';
import '../../models/framework.dart';
import './additem.dart';
import './edititem.dart';

class ItemsPage extends StatefulWidget {
  final Album album;
  ItemsPage({Key key, this.album}) : super(key: key);
  @override
  createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  int refresh = 0;
  FirestoreServices fb = new FirestoreServices();

  addItemPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemPage(album: album),
      ),
    );
    setState(() {
      refresh = 1;
    });
  }

  editItemPage(BuildContext context, Item item, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(album: album, item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.albumName),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addItemPage(context, widget.album);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(4.0),
        child: StreamBuilder(
          stream: FirestoreService().getItems1(widget.album.albumName),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError)
              return new Text('Loading...');
           
            else if(snapshot.hasData) {
            return GridView.builder(
              
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),

              itemCount:snapshot.data.length,
              //snapshot.data.length,
              itemBuilder: (BuildContext context, int index ) {
                Item item = snapshot.data[index];
                
                return GestureDetector(
                  onDoubleTap: () {
                    editItemPage(context, item, widget.album);
                  },
                  child: Column(
                    children: <Widget>[
                      Text("hello"),
                      Image.network(
                        item.itemImage,
                        height: 150.0,
                        width: 150.0,
                      ),
                    ],
                  ),
                );
              },
            );
            }
            else {
            return Text("Album is empty");
            }
          },
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(widget.album.albumName),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.add),
  //       onPressed: () {
  //         addItemPage(context, widget.album);
  //       },
  //     ),
  //     body:
  //     // ListView(
  //     //   padding: EdgeInsets.all(20.0),
  //     //   children: <Widget>[
  //         // Wrap(

  //         //   alignment: WrapAlignment.spaceEvenly,
  //         //   runSpacing: 40.0,
  //         //   children: <Widget>[
  //         StreamBuilder(
  //           stream: FirestoreService().getItems1(),
  //           builder: (BuildContext context, AsyncSnapshot snapshot) {
  //             if (snapshot.hasError || !snapshot.hasData)
  //               return new Text('Loading...');

  //             return ListView.builder(
  //                  padding: EdgeInsets.all(20.0),
  //               //  scrollDirection: Axis.vertical,
  //               shrinkWrap: true,
  //               itemCount: snapshot.data.length,
  //               //snapshot.data.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 Item item = snapshot.data[index];
  //               return  Wrap(
  //                     alignment: WrapAlignment.spaceEvenly,
  //           runSpacing: 40.0,

  //             children: <Widget>[
  //                 GestureDetector(

  //                     onDoubleTap: () {
  //                     editItemPage(context, item, widget.album);
  //                   },
  //                   child: Column(

  //                     children: <Widget>[
  //                       // Text(),
  //                       // Text(widget.album.items[0].itemImage.toString()),
  //                       Image.network(
  //                         item.itemImage,
  //                         //"https://img.icons8.com/material/4ac144/256/user-male.png",
  //                         // "https://firebasestorage.googleapis.com/v0/b/photo-library-6f70a.appspot.com/o/a/2020-01-02 11:59:03.001134.jpg?alt=media&token=52f3e2ce-89b4-449d-ba43-bfb702f2cdcf",
  //                         //item.itemImage,

  //                         height: 150.0,
  //                         width: 150.0,
  //                       ),
  //                     ],
  //                   ),

  //                 ),

  //             ]

  //                 );

  //                 return GestureDetector(
  //                   onDoubleTap: () {
  //                     editItemPage(context, item, widget.album);
  //                   },
  //                   child: Column(

  //                     children: <Widget>[
  //                       // Text(),
  //                       // Text(widget.album.items[0].itemImage.toString()),
  //                       Image.network(
  //                         item.itemImage,
  //                         //"https://img.icons8.com/material/4ac144/256/user-male.png",
  //                         // "https://firebasestorage.googleapis.com/v0/b/photo-library-6f70a.appspot.com/o/a/2020-01-02 11:59:03.001134.jpg?alt=media&token=52f3e2ce-89b4-449d-ba43-bfb702f2cdcf",
  //                         //item.itemImage,

  //                         height: 150.0,
  //                         width: 150.0,
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //         //  ],

  //         // children: widget.album.items != null
  //         //     ? widget.album.items
  //         //         .map((item) => GestureDetector(
  //         //             onDoubleTap: () {
  //         //               editItemPage(context, item, widget.album);
  //         //             },
  //         //             child: Column(
  //         //               children: <Widget>[
  //         //                 Text(widget.album.items[0].itemImage.toString()),
  //         //                 Image.network(
  //         //                   "https://img.icons8.com/material/4ac144/256/user-male.png",
  //         //                  // "https://firebasestorage.googleapis.com/v0/b/photo-library-6f70a.appspot.com/o/a/2020-01-02 11:59:03.001134.jpg?alt=media&token=52f3e2ce-89b4-449d-ba43-bfb702f2cdcf",
  //         //                   //item.itemImage,

  //         //                   height: 150.0,
  //         //                   width: 150.0,
  //         //                 ),

  //         //               ],
  //         //             )))
  //         //         .toList()
  //         //     : Text('Album is Empty'),

  //         //   ),
  //         // SizedBox(
  //         //   height: 15.0,
  //         // ),
  //         // FloatingActionButton(
  //         //   child: Icon(Icons.add),
  //         //   onPressed: () {
  //         //     addItemPage(context, widget.album);
  //         //   },
  //         // ),
  //     //   ],
  //     // ),
  //   );
  // }

}
