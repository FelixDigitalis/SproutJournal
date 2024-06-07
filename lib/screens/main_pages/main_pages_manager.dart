import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../database_services/firebase/firebase_auth.dart';
import '../elements/bottom_bar_element.dart';
import '../sub_pages/settings_page.dart';
import 'gartenfreunde_page.dart';
import 'journal_feed.dart';
import 'library_feed.dart';
import '../sub_pages/gartenfreunde/gartenfreunde_user_search.dart';

class PageManager extends StatefulWidget {
  final int selectedIndex;
  const PageManager({super.key, this.selectedIndex = 0});

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  late int _selectedIndex;
  late String _appBarTitle;
  final AuthService _auth = AuthService();

  final List<Widget> _widgetOptions = <Widget>[
    const JournalFeed(),
    const PlantFeed(),  // Corrected PlantFeed to LibraryFeed
    const GartenfreundePage(),
  ];

  final List<String> _titles = [
    'SproutJournal 🌱',
    'SproutJournal 🌱',
    'Gartenfreunde 🌱',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _appBarTitle = _titles[_selectedIndex];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _appBarTitle = _titles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_appBarTitle,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsMenu()),
              );
            },
          ),
          if (user != null && _selectedIndex == 2) ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GartenfreundeUserSearch(
                            user: user,
                            onFollowStatusChanged: (status) {
                              if (status == true) {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              }
                            },
                          )),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomBarElement(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
