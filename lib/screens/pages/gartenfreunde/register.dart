import '../../../services/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  String password = '';
  String firstname = '';
  String lastname = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
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
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Passwort',
                    border: OutlineInputBorder(),
                  ),
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Vorname',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vornamen eingeben';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => firstname = val);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Nachname',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Nachnamen eingeben';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() => lastname = val);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          widget.email, password, firstname, lastname);
                      if (result == null) {
                        setState(() => error = 'Registrieren fehlgeschlagen');
                      } else {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: const Text('Registrieren'),
                ),
                Text(error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
