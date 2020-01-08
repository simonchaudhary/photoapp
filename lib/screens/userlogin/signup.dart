import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String confirmPassword = '';

  signupConfirm() {
    if (email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty &&
        password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please complete the required fields"),
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
    } else if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Error"),
            content: Text("Password donot match"),
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
    } else {
      return true;
    }
  }

  validateAndSubmit() async {
    if (signupConfirm()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print('Registered in:${user.uid}');

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Success"),
              content: Text("Created account with email " + email),
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
      } catch (e) {
        print('Error:$e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "The email address is already in use by another account"),
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
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            TextField(
              autofocus: false,
              autocorrect: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "Email",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              autofocus: false,
              autocorrect: true,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Password",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              autofocus: false,
              autocorrect: true,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Confirm Password",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              child: Text(
                'Submit',
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
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Login Here',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
