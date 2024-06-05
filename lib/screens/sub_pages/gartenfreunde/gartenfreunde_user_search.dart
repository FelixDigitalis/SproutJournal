import 'package:flutter/material.dart';
import '../../../database_services/firebase/firebase_service.dart';
import '../../../models/user_model.dart';
import '../../../utils/log.dart';

class GartenfreundeUserSearch extends StatefulWidget {
  final UserModel user;
  const GartenfreundeUserSearch({required this.user, super.key});

  @override
  GartenfreundeUserSearchState createState() => GartenfreundeUserSearchState();
}

class GartenfreundeUserSearchState extends State<GartenfreundeUserSearch> {
  late FirebaseService _fbService;
  late String uid;
  String searchQuery = '';
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
     uid = widget.user.uid;
     _fbService = FirebaseService(uid: uid);
    _initializeSearch();
  }

  Future<void> _initializeSearch() async {
    setState(() {
      // Initialize search with user's followed nicknames or other data if needed
    });
  }

  void _searchNicknames(String query) async {
    List<String> results = await _fbService.searchNicknames(query);
    setState(() {
      searchResults = results;
    });
  }

  void _toggleFollowStatus(String nickname) {
    setState(() {
      if (widget.user.followedNicknames.contains(nickname)) {
        widget.user.followedNicknames.remove(nickname);
        _fbService.unfollowUser(nickname);
      } else {
        widget.user.followedNicknames.add(nickname);
        _fbService.followUser(nickname);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    Log().d(widget.user.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benutzer suchen',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Suche nach Nickname',
                labelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
                _searchNicknames(val);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  String nickname = searchResults[index];
                  bool isFollowed =
                      widget.user.followedNicknames.contains(nickname);
                  return ListTile(
                    title: Text(
                      nickname,
                      style: TextStyle(color: primaryColor),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFollowed ? Icons.remove_circle : Icons.add_circle,
                        color: isFollowed ? Colors.red : Colors.green,
                      ),
                      onPressed: () => _toggleFollowStatus(nickname),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
