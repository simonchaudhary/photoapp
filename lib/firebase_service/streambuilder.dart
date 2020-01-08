import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class MountainList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new StreamBuilder(
//       stream: Firestore.instance.collection('user1').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) return new Text('Loading...');
//         return new ListView(



          
//           children: snapshot.data.documents.map((document) {
//             return new Text(
//               title: new Text(document['title']),
//               subtitle: new Text(document['type']),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

class StreamData {

  albumName( AsyncSnapshot snapshot)  {
    String albumName;
    snapshot.data.documents.map((document){
          albumName = document["albumName"];
      //  albumName = "data";

    }).toList();
   return albumName;
  }
}


