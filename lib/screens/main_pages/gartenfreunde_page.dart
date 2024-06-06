import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../sub_pages/gartenfreunde/gartenfreunde_welcome.dart';
import '../../../utils/log.dart';
import '../elements/gartenfreunde_posting_element.dart';
import '../elements/gartenfreunde_feed_element.dart';

class GartenfreundePage extends StatefulWidget {
  const GartenfreundePage({super.key});

  @override
  State<GartenfreundePage> createState() => _GartenfreundePageState();
}

class _GartenfreundePageState extends State<GartenfreundePage> {

  @override
  Widget build(BuildContext context) {
    try {
      final user = Provider.of<UserModel?>(context);

      if (user == null) {
        return const GartenfreundeWelcome();
      }

      final username = user.nickname;

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi $username 👋',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20)),
              const SizedBox(height: 20),
              const GartenfreundePostingElement(),
              const SizedBox(height: 20),
              const Expanded(
                child: GartenfreundeFeedElement(),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Log().e('Error in GartenfreundePage build method: $e');
      return Scaffold(
        body: Center(
          child: Text('Ein Fehler ist aufgetreten: $e'),
        ),
      );
    }
  }
}
