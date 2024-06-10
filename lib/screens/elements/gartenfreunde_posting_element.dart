import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../utils/log.dart';
import '../../services/post_notifer.dart';

class GartenfreundePostingElement extends StatefulWidget {
  const GartenfreundePostingElement({super.key});

  @override
  GartenfreundePostingElementState createState() =>
      GartenfreundePostingElementState();
}

class GartenfreundePostingElementState
    extends State<GartenfreundePostingElement> {
  final _postController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Center(child: Text('Fehler. Bitte logge dich ein.'));
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _postController,
            decoration: InputDecoration(
              hintText: 'Was möchtest du teilen?',
              hintStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
              ),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 18),
            maxLines: null,
          ),
        ),
        const SizedBox(width: 10),
        _isLoading
            ? const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final content = _postController.text;
                    if (content.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final postNotifier =
                            Provider.of<PostNotifier>(context, listen: false);
                        await postNotifier.addPost(user.uid, content);
                        _postController.clear();
                      } catch (e) {
                        Log().e('Failed to add post: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gebe eine Nachricht ein!')),
                      );
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
