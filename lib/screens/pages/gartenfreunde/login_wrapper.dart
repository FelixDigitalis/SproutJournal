import 'package:flutter/material.dart';
import 'authenticate.dart';
import '../../main_pages/main_pages_manager.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return PageManager();
    }

  }
}