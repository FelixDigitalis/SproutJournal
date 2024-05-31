import '../../../services/firebase/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einloggen'),
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
                Text(error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
