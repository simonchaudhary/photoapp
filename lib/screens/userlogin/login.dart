import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  loginConfirm() {
    if (email != '' && email != null && password != '' && password != null) {
      return true;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter username and password"),
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
      return false;
    }
  }

  validateAndSubmit() async {
    if (loginConfirm()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print('Signed in:${user.uid}');
        Navigator.of(context).pushNamed('/library');
        _emailController.clear();
        _passwordController.clear();
      } catch (e) {
        print('Error:$e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Error"),
              content: Text("Invalid username and password"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autofocus: false,
                autocorrect: true,
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                autofocus: false,
                autocorrect: true,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Password",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  validateAndSubmit();
                },
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              InkWell(
                // When the user taps the button, show a snackbar.
                onTap: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Dont have an account?',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
