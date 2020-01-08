import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './models/framework.dart';
import './screens/library.dart';
import 'res/colors.dart';
import 'screens/album/addalbum.dart';
import './screens/items/items.dart';
import './screens/userlogin/login.dart';
import './screens/userlogin/signup.dart';

class App extends StatefulWidget {
  final Library myLib;
  const App({Key key, this.myLib}) : super(key: key);

  @override
  createState() => _AppState();
}

class _AppState extends State<App>{
  String _content;
  bool loginEnter=true;
  
  @override
  void initState(){
    super.initState(); 
    widget.myLib.initLib().then((onValue){
      setState((){
        _content = onValue;
        loginEnter=true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<Library>(
      model: widget.myLib,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Library1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: lightBlackBG
        ),
        home:loginEnter?LoginPage():LibraryPage(), 
        routes: <String, WidgetBuilder>{
          '/library': (BuildContext context) => LibraryPage(),
          '/addalbum': (BuildContext context) => AddAlbumPage(),
          '/items':(BuildContext context) => ItemsPage(),
          '/login':(BuildContext context) => LoginPage(),
          '/signup':(BuildContext context) => SignUpPage(),          
        },
      ),
    );
  }
}
