import 'package:flutter/material.dart';
import 'screens/main_pages/main_pages_manager.dart';
import 'utils/log.dart';
import 'models/user_model.dart';
import 'database_services/firebase/firebase_auth.dart';
import 'package:provider/provider.dart';
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
        home: const PageManager(),
      ),
    );
  }
}
