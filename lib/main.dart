import 'package:flutter/material.dart';
import './models/framework.dart';
import 'App.dart';
//import 'dart:convert';
//import 'framework.dart';

void main() {
  // Map userMap = jsonDecode(jsonString);
  runApp(App(myLib: Library.defaultName(),));
}
