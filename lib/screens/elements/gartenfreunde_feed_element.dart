import 'package:flutter/material.dart';
import '../../database_services/firebase/firebase_service.dart';
import '../../models/post_model.dart';
import '../../../utils/log.dart';

class GartenfreundeFeedElement extends StatefulWidget {
  const GartenfreundeFeedElement({super.key});

  @override
  _GartenfreundeFeedElementState createState() => _GartenfreundeFeedElementState();
}

class _GartenfreundeFeedElementState extends State<GartenfreundeFeedElement> {
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = FirebaseService().getPostsFromFollowedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          Log().e('Error fetching posts: ${snapshot.error}');
          return Center(child: Text('Ein Fehler ist aufgetreten: ${snapshot.error}'));
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
                child: ListTile(
                  title: Text(post.content),
                  subtitle: Text('Von: ${post.authorName}'),
                ),
              );
            },
          );
        }
      },
    );
  }
}
