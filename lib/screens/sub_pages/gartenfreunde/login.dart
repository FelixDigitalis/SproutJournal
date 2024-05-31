import 'package:flutter/material.dart';
import '../../../database_services/firebase/firebase_auth.dart';

class SignIn extends StatefulWidget {
  final String email;

  const SignIn({
    super.key,
    required this.email,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einloggen',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Passwort',
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
                    if (val == null || val.isEmpty) {
                      return 'Passwort eingeben';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      dynamic result = await _auth.signInWithEmailAndPassword(widget.email, password);
                      if (result == null) {
                        setState(() => error = 'Einloggen fehlgeschlagen');
                      } else {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  child: const Text('Einloggen'),
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
