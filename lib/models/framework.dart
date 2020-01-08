// void main() {

//  //Create new user
//  //Create 5(pkr,dhangadi,chtwn,ktm,htd) album for this user
//  //Insert new item on this album
//  //Modify the album name
//  //Rename the item name
//  //Insert another Item
//  //Add 5 tags to this item
//  //Insert 5 items to each album
//  //Show albums in Library
//  //Show images in an album
//  //Show all content of library

//  User user = new User("birat11");
//  print('username is ${user.uid}');

//  Album a1 = new Album("Pokhara Album");

//  Library library1 = new Library("Library1",user);

//  library1.create_album(a1);

//  Item i11 = new Item("Item1","Item1_url");
//  Item i12 = new Item("Item2","Item2_url");
//  Item i13 = new Item("Item3","Item3_url");
//  Item i14 = new Item("Item4","Item4_url");
//  Item i15 = new Item("Item5","Item5_url");

//  a1.add_item(i11);
//  a1.add_item(i12);
//  a1.add_item(i13);
//  a1.add_item(i14);
//  a1.add_item(i15);

//  library1.show_albums();
//  a1.show_items();
// }

import 'dart:convert';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_app_gh/screens/items/additem.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class User {
  String uid;
  String email;
  dynamic userpassword;

  User({
    this.uid,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
    );
  }

  toJson() => {
        'uid': uid,
        'email': email,
      };
}

class Library extends Model {
  User usr;
  String libraryName;
  List<Album> 
  albums;

  Future<String> initLib() async {
    String myLibAppSeedContent;
    try {
      myLibAppSeedContent = await readSeedFile();
      if (myLibAppSeedContent != null) {
        print(
            '++>>app seed file already exist. Reading seedFile and instanciating library...');
        loadLibraryfromjsonstring(myLibAppSeedContent) {
          Library library2 = new Library();
          final jsonResponse = jsonDecode(myLibAppSeedContent);
          User u = User.fromJson(jsonResponse["user"]);
          library2.usr = u;
          List albumsJsonList = jsonResponse["albums"];
          List albums = new List<Album>();
          if (albumsJsonList.length > 0) {
            for (Map albumJson in albumsJsonList) {
              Album album = new Album();
              print("albumJson = " + albumJson.toString());
              String aName = albumJson["albumName"];
              print(aName);

              album.albumName = aName;

              List itemsJsonList = albumJson["items"];

              List items = new List<Item>();
              if (itemsJsonList.length > 0) {
                for (Map itemJson in itemsJsonList) {
                  Item item = new Item();
                  print("itemJson = " + itemJson.toString());
                  String itemDes = itemJson["itemDescription"];
                  item.itemDescr = itemDes;
                  print(itemDes);

                  dynamic imgUrl = itemJson["image"];
                  item.itemImage = imgUrl;
                  print(imgUrl);

                  items.add(item);
                } //for loop through list of items
              } //if itemsJson length is > 0
              album.items = items;
              albums.add(album);
            } //for loop through list of Albums
          }
          return (albums);
        }

        print(myLibAppSeedContent);
        return myLibAppSeedContent +
            "A:" +
            new DateFormat("dd-MM-yy hh:mm:ss").format(new DateTime.now());
      } else {
        //createSeedFile();
        print('++>>app seed file does not exist. Calling  writeSeedFile...');
        myLibAppSeedContent = "C: " +
            new DateFormat("dd-MM-yy hh:mm:ss").format(new DateTime.now());
        print('++>> with myLibAppSeedContent = ' + myLibAppSeedContent);
        await writeSeedFile(myLibAppSeedContent).then((onValue) {
          if (onValue) {
            print('++>>write file successful...');

            return myLibAppSeedContent;
          } else {
            print('++>>write file Failed...');
            return null;
          }
        });
        return myLibAppSeedContent;
      }
    } catch (e) {
      print('Exception occured' + e);
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    var output = File('$path/libContent.json');
    return output;
  }

  Future<String> readSeedFile() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<bool> writeSeedFile(String appSeedInfo) async {
    try {
      final file = await _localFile;

      // Write the file
      file.writeAsString(appSeedInfo);
      return true;
    } catch (e) {
      // If encountering an error, return 0
      return false;
    }
  }

  Library({
    this.usr,
    this.libraryName,
    this.albums,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      usr: json['user'].map((value) => User.fromJson(value)).toList(),
      libraryName: json['libraryName'],
      albums: json['albums'].map((value) => Album.fromJson(value)).toList(),
    );
  }

  toJson() => {
        'users': usr,
        'libraryName': libraryName,
        'albums': albums,
      };

  Library.defaultName() {
    this.usr = null;
    this.libraryName = "Default Library";
    albums = List<Album>();
  }

  Library.withName(User usr, String name) {
    this.usr = usr;
    this.libraryName = name;
    albums = List<Album>();
  }

  Library.withAlbum(String name, User usr, Album album) {
    this.usr = usr;
    this.libraryName = name;
    albums = List<Album>();
    this.albums.add(album);
  }

  setLibName(String name) {
    this.libraryName = name;
    notifyListeners();
  }

  setUserName(User usr) {
    this.usr = usr;
    notifyListeners();
  }

  getModifiedAlbum() {
    print('Here is the list of modified album');
    if (albums != null) {
      for (Album a in albums) {
        a.showModifiedAlbumName();
      }
    }
    notifyListeners();
  }

  createAlbum(String album, dynamic albumIcon) {
    Album a = Album.withIcon(album, albumIcon);
    a.isAlbumModified = true;
    //a.addItem(name, image, tags)
    this.albums.add(a);
    notifyListeners();
  }

  removeAlbum(Album album) {
    this.albums.remove(album);
    notifyListeners();
  }

  getItemByTagLib(String searchTag) {
    if (albums != null) {
      for (Album a in albums) {
        a.getItemByTagAlbum(searchTag);
      }
    }
  }

  showAlbums() {
    //iterate through the album list and show album name
    if (albums != null) {
      for (Album a in albums) {
        a.showAlbumName();
      }
    }
  }

  showLibraryContents() {
    //   iterate through albums and for each album call album.show_items
    //  if(albums!=null){
    //     for(Album a in albums){
    //       a.show_album_name();
    //       a.showitems();
    //     }
    //   }
  }
}

class Album extends Model {
  String albumName;
  dynamic albumIcon;
  List itemNames;
  List<Item> items;
  bool isAlbumModified = false;
  //Item item = Item();
  String id;

  Album({
    this.albumName,
    this.albumIcon,
    this.items,
    this.isAlbumModified,
    this.id,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        albumName: json['albumName'],
        albumIcon: json['albumIcon'],
        isAlbumModified: json['isAlbumModified'],
        items: (json['items'] as List).map((value) { 
          
          return Item.fromJson(value);
          }).toList(),
      );
  }

   Album returnAlbum(Map<String, dynamic> data) {
      
     // List<Item> items = new List<Item>() ;
      String aName ;
      dynamic aIcon;
     
     
      // data["items"].forEach(( data) {
      // //   var itemDescription = data['itemDescription'].toString();
      // //   var image = data["image"].toString();
      // //   List itemTags =data['itemTags'];
      // //  // bool isItemModified = data['isItemModified'];
      // //   // print(data);
         
      // //   // print(image);
      // //   items.add(Item(itemDescr: "Datga"));
      //   print("itemDescription");
      //    },);
        getData();
      //print(check1.runtimeType);
    // print("Cheking data of items = " + items[0].itemImage.toString());
      aName = data["albumName"];
      aIcon = data['albumIcon'];
     // isAlbumModified =data['isAlbumModified'];
     // items = FirestoreService().getItems();
    //  items =newItems;
    

     return Album(
       //items: data["items"][0],
        albumName:aName ,
        albumIcon:aIcon,
        items: getItems( data["items"]),

        // items: data["items"].forEach((i){


        // }
       // )
        
      //  isAlbumModified: isAlbumModified,
      //  items: json['items'].map((value) => Item.fromJson(value)).toList()
      );
      
    }


     getData() {
      final db =  Firestore.instance;
      List<Item> items = new List<Item>() ;

     db.collection('user1').document("user1").collection("albums")
     .document("a")
     .collection("items")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) {
      var data = f.data;
     
 //     print(data);
      
    });
  });
}

   List<Item> getItems(List datas) {

        List<Item> newItems = new List();
     
      // datas.forEach((f) {
       
  
      //   print("data");
       
      //   // newItems.add(Item (itemDescr :itemDescription , itemTags: itemTags  ));
     
      //    }
      //    );

       //  items =  newItems;
       // print("Cheking data of items = " + newItems[0].itemDescr.toString());
         return newItems;

     //  print(check1.runtimeType);
      
    }

  

 List itemList(List itms,String url){
    List items = new List();
    for(int i=0 ;i<itms.length;i++) {
        items.add(itms[i].toJson(url));
    }
    return items;

  }
  
  List itemNameList(List itms){
    List items = new List();
    for(int i=0 ;i<itms.length;i++) {
        items.add(itms[i].itemDescr);
    }
    return items;

  }

 

  toJson(String url) => {
        'albumName': albumName,
        'albumIcon': albumIcon,
        'isAlbumModified': isAlbumModified,
        'itemNames' :itemNameList(items),
       // 'itemNames' :items.last.itemDescr,
       // 'items':items.last.toJson(url),
        'items':itemList(items, url),
      };


  Map<String, String> tojson() => {
        "itemDescription": "itemDescr",
        'image': "itemImage",
      };

  Album.withIcon(String name, dynamic albumIcon) {
    this.albumName = name;
    this.albumIcon = albumIcon;
    items = List();
  }

  addItem(String name, File image, List<String> tags) {
    Item i = Item.withIcon(name, image, tags);
    i.isItemModified = true;
    this.items.add(i);
    notifyListeners();
  }

  showAlbumName() {
    print("album name:${this.albumName}");
  }

  showModifiedAlbumName() {
    if (this.isAlbumModified == true) {
      print("${this.albumName}");
    }
    notifyListeners();
  }

  editAlbum(String name, dynamic albumIcon) {
    this.albumName = name;
    this.albumIcon = albumIcon;
    this.isAlbumModified = true;
    notifyListeners();
  }

  showItems() {
    //iterate through item list and print item name,tags and image
    if (items != null) {
      for (Item i in items) {
        i.showItemDetail();
      }
    }
  }

  removeItem(Item item) {
    this.items.remove(item);
    notifyListeners();
  }

  getItemByTagAlbum(String searchTag) {
    if (items != null) {
      for (Item i in items) {
        if (i.itemTags.contains(searchTag)) {
          return true;
        }
      }
    }
  }
}

AddItemPage ap = new AddItemPage();

class Item {
  String itemDescr;
  List<String> itemTags;
  //Image img;
  dynamic itemImage;
  bool isItemModified = false;

  Item({
    this.itemDescr,
    this.itemImage,
    this.itemTags,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemDescr: json['itemDescription'],
      itemImage: json['image'],
     // itemTags: json['imageTags'].map((value) => value).toList()
    );
  }

  toJson(String url) => {
        'itemDescription': itemDescr,
        'image': url,
        'isItemModified': isItemModified,
        'imageTags': itemTags,
      };

  // itemNamesJson()=>{


  // }

  Item.withIcon(String name, dynamic image, List<String> tags) {
    this.itemDescr = name;
    this.itemImage = image;
    itemTags = List<String>();
    this.itemTags = tags;
  }

  renameImage(String name) {
    this.itemDescr = name;
  }

  editItem(String name, dynamic image, List tags) {
    this.itemDescr = name;
    this.itemImage = image;
    this.itemTags = tags;
  }

  showItemDetail() {
    print("item description:${this.itemDescr}");
    if (itemTags != null) {
      for (String t in itemTags) {
        print("Items tag:$t");
      }
    }
  }

  getItemByTagItem(String searchTag) {
    if (itemTags != null) {
      if (this.itemTags.contains(searchTag)) {
        return true;
      }
    }
  }
}
