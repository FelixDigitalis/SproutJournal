import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/main_pages/main_pages_manager.dart';
import 'utils/log.dart';
import 'models/user_model.dart';
import 'database_services/firebase/firebase_auth.dart';
import 'services/post_notifer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Log().i("App started!");

    return MultiProvider(
      providers: [
        StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
          catchError: (_, __) => null,
        ),
        ChangeNotifierProvider(create: (_) => PostNotifier()),
      ],
      child: MaterialApp(
        title: 'SproutJournal',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(46, 125, 50, 1),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromRGBO(46, 125, 50, 1),
            onPrimary: Colors.white,
            secondary: Color.fromRGBO(194, 222, 162, 1),
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.lightGreen,
            onSurface: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _checkAndRequestPermissions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for permissions
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              // Show an error message if something goes wrong
              return Scaffold(
                body: Center(
                  child: Text('Error requesting permissions: ${snapshot.error}'),
                ),
              );
            } else if (snapshot.data == true) {
              // If permissions are granted, show the main content
              return const MainPagesManager();
            } else {
              // If permissions are not granted, show a message
              return const Scaffold(
                body: Center(
                  child: Text('Bitte gewähren Sie die benötigten Berechtigungen!'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkAndRequestPermissions() async {
    Log().i("Checking permissions");

    // Check and request storage permissions
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }
}
