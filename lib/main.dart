import 'package:flutter/material.dart';
import 'app.dart';
import './services/log.dart';


void main() async {
  Log().i("Main started");

  runApp(const App());
}
