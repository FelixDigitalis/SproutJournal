import 'package:flutter/material.dart';
import 'app.dart';
import 'package:logger/logger.dart';


// TODO: define colors file annd change colr uses in file
void main() {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  // Logger loggerNoStack = Logger(
  //   printer: PrettyPrinter(methodCount: 0),
  // );

  logger.i("Main started");

  runApp(const App());
}
