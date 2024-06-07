
import 'package:flutter/material.dart';
import 'package:sprout_journal/screens/main_pages/main_pages_manager.dart';
import '../../../database_services/firebase/firebase_auth.dart';
import '../../../database_services/firebase/firebase_service.dart';

class Register extends StatefulWidget {
  final String email;

  const Register({
    super.key,
    required this.email,
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _fbService = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  String password = '';
  String nickname = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrieren',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white), // This sets the back arrow color to white
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: widget.email,
                    enabled: false,
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (val) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Passwort',
                    hintStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Passwort eingeben';
                    } else if (val.length < 6) {
                      return 'Passwort muss mind. 6 Zeichen haben';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nickname',
                    hintStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Nickname eingeben';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => nickname = val);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      bool nicknameTaken =
                          await _fbService.isNicknameTaken(nickname);
                      if (nicknameTaken) {
                        setState(() {
                          error = 'Nickname bereits vergeben';
                        });
                      } else {
                        dynamic result =
                            await _auth.registerWithEmailAndPassword(
                                widget.email, password, nickname);
                        if (result == null) {
                          setState(() {
                            error = 'Registrieren fehlgeschlagen';
                          });
                        } else {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PageManager(
                                  selectedIndex: 2,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: const Text('Registrieren',
                      style: TextStyle(color: Colors.white)),
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}