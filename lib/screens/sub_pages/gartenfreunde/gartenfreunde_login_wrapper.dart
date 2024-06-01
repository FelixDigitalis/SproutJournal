import 'package:flutter/material.dart';
import 'gartenfreunde_authenticate.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../utils/log.dart';

class Wrapper extends StatelessWidget {
  final Widget child;

  const Wrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Log().d("Wrapper started!");

    try {
      final user = Provider.of<UserModel?>(context);
      if (user == null) {
        return const GartenfreundeAuthenticate();
      } else {}
    } catch (e) {
      Log().e("Error in Wrapper: $e");
    }
    return child;
  }
}
