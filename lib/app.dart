import 'package:flutter/material.dart';
import 'screens/main_pages/main_pages_manager.dart';
import './services/log.dart';


class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    Log().i("App started!");
    return MaterialApp(
      title: 'SproutJournal',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(46, 125, 50, 1),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromRGBO(46, 125, 50, 1),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(194, 222, 162, 1),
          onSecondary: Colors.black,
          error:  Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.lightGreen,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor:Colors.white,
      ),
      home: const PageManager(), 
    );
  }
}
