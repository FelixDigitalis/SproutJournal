import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../utils/log.dart';
import '../../services/post_notifer.dart';


class GartenfreundeFeedElement extends StatefulWidget {
  const GartenfreundeFeedElement({super.key});

  @override
  GartenfreundeFeedElementState createState() => GartenfreundeFeedElementState();
}

class GartenfreundeFeedElementState extends State<GartenfreundeFeedElement> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPosts();
    });
  }

  Future<void> _fetchPosts() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user != null) {
      final postNotifier = Provider.of<PostNotifier>(context, listen: false);
      await postNotifier.fetchPosts(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final postNotifier = Provider.of<PostNotifier>(context);

    if (user == null) {
      return const Center(child: Text('Error fetching posts'));
    }

    if (postNotifier.isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    final posts = postNotifier.posts;
    if (posts.isEmpty) {
      return const Center(child: Text('Keine Beiträge vorhanden.'));
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final isUserPost = post.authorName == user.nickname;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: isUserPost ? Theme.of(context).secondaryHeaderColor : Colors.black),
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
                isUserPost ? 'Von Dir am ${post.timestamp}' : 'Von ${post.authorName} am ${post.timestamp}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onLongPress: isUserPost ? () async {
                await _showDeleteDialog(context, post.id, user.uid);
              } : null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String postId, String uid) async {
    final postNotifier = Provider.of<PostNotifier>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Beitrag löschen'),
          content: const Text('Möchtest du diesen Beitrag wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Löschen'),
              onPressed: () async {
                try {
                  await postNotifier.deletePost(uid, postId);
                  Navigator.of(context).pop();
                } catch (e) {
                  Log().e('Failed to delete post: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
