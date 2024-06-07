import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprout_journal/models/user_model.dart';
import '../../database_services/firebase/firebase_service.dart';
import '../../models/post_model.dart';
import '../../../utils/log.dart';

class GartenfreundeFeedElement extends StatefulWidget {
  const GartenfreundeFeedElement({super.key});

  @override
  GartenfreundeFeedElementState createState() => GartenfreundeFeedElementState();
}

class GartenfreundeFeedElementState extends State<GartenfreundeFeedElement> {

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const Center(child: Text('Error fetching posts'));
    }
    return FutureBuilder<List<PostModel>>(
      future: FirebaseService(uid: user.uid).getPostsFromFollowedUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          Log().e('Error fetching posts: ${snapshot.error}');
          return const Center(child: Text('Ein Fehler ist aufgetreten.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Keine Beiträge vorhanden.'));
        } else {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      post.content,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      'Von ${post.authorName} am ${post.timestamp}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
