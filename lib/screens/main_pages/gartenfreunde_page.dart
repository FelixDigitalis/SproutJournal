import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../sub_pages/gartenfreunde/gartenfreunde_welcome.dart';
import '../../../utils/log.dart';

class GartenfreundePage extends StatefulWidget {
  const GartenfreundePage({super.key});

  @override
  State<GartenfreundePage> createState() => _GartenfreundePageState();
}

class _GartenfreundePageState extends State<GartenfreundePage> {
  final _postController = TextEditingController();

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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        hintText: 'Was möchtest du teilen?',
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement the sharing functionality
                      _postController.clear();
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Feed',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
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

  @override
  void dispose() {
    _postController.dispose();
    Log().d("GartenfreundePage disposed!");
    super.dispose();
  }
}
