import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../database_services/firebase/firebase_service.dart';
import '../../../utils/log.dart';

class GartenfreundePostingElement extends StatefulWidget {
  const GartenfreundePostingElement({super.key});

  @override
  _GartenfreundePostingElementState createState() => _GartenfreundePostingElementState();
}

class _GartenfreundePostingElementState extends State<GartenfreundePostingElement> {
  final _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Center(child: Text('Please log in to post.'));
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
        ElevatedButton(
          onPressed: () async {
            final content = _postController.text;
            if (content.isNotEmpty) {
              try {
                await FirebaseService(uid: user.uid).addPost(content);
                _postController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post added successfully!')),
                );
              } catch (e) {
                Log().e('Failed to add post: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add post: $e')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post content cannot be empty.')),
              );
            }
          },
          child: const Icon(Icons.send),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    Log().d("GartenfreundePostingElement disposed!");
    super.dispose();
  }
}
