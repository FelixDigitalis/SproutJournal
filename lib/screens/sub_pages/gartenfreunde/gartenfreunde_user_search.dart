import 'package:flutter/material.dart';
import '../../../database_services/firebase/firebase_service.dart';

class GartenfreundeUserSearch extends StatefulWidget {
  const GartenfreundeUserSearch({super.key});

  @override
  GartenfreundeUserSearchState createState() => GartenfreundeUserSearchState();
}

class GartenfreundeUserSearchState extends State<GartenfreundeUserSearch> {
  final FirebaseService _fbService = FirebaseService();
  String searchQuery = '';
  List<String> searchResults = [];

  void _searchNicknames(String query) async {
    List<String> results = await _fbService.searchNicknames(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benutzer suchen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Suche nach Nickname',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
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
                  return ListTile(
                    title: Text(searchResults[index]),
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
