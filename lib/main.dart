import 'package:flutter/material.dart';
import 'app.dart';
import 'package:logger/logger.dart';


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
