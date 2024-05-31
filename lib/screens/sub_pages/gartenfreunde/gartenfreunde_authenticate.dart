import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import '../../../database_services/firebase/firebase_service.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();

  String email = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Willkommen bei Gartenfreunde',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'E-Mail',
                      hintStyle: TextStyle(color: primaryColor, fontSize: 18),
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
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    validator: (val) {
                      String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,5}\b';
                      RegExp regex = RegExp(pattern);
                      if (val == null || val.isEmpty) {
                        return 'E-Mail Adresse eingeben';
                      } else if (!regex.hasMatch(val)) {
                        return 'keine gültige Email Adresse';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        bool userAlreadyExists =
                            await FirebaseService().isUserRegistered(email);
                        if (mounted) {
                          if (userAlreadyExists) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn(email: email)),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register(email: email)),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Fortfahren', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
