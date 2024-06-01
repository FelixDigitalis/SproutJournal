import 'package:flutter/material.dart';
import 'package:sprout_journal/utils/log.dart';
import 'gartenfreunde_login.dart';
import 'gartenfreunde_register.dart';
import '../../../database_services/firebase/firebase_service.dart';

class GartenfreundeAuthenticate extends StatefulWidget {
  const GartenfreundeAuthenticate({super.key});

  @override
  State<GartenfreundeAuthenticate> createState() =>
      _GartenfreundeAuthenticateState();
}

class _GartenfreundeAuthenticateState extends State<GartenfreundeAuthenticate> {
  final _formKey = GlobalKey<FormState>();

  String email = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    Log().d("Authenticating user");

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
                  SizedBox(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'E-Mail',
                        hintStyle: TextStyle(color: primaryColor, fontSize: 18),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryColor, width: 2.0),
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
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
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
                                    builder: (context) =>
                                        Register(email: email)),
                              );
                            }
                          }
                        } catch (e) {
                          Log().e('Error in Authenticate: $e');
                          throw Exception('Error in Authenticate: $e');
                        }
                      }
                    },
                    child: const Text('Fortfahren'),
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
