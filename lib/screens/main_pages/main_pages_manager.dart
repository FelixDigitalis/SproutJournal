import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprout_journal/utils/log.dart';
import '../../../models/user_model.dart';
import '../../../database_services/firebase/firebase_auth.dart';
import '../elements/bottom_bar_element.dart';
import '../sub_pages/settings_page.dart';
import 'gartenfreunde_page.dart';
import 'journal_feed.dart';
import 'library_feed.dart';
import '../sub_pages/gartenfreunde/gartenfreunde_user_search.dart';

class MainPagesManager extends StatefulWidget {
  /* Class that manages all pages that can be reached by the main bottom bar */
  final int selectedIndex;
  const MainPagesManager({super.key, this.selectedIndex = 0});

  @override
  State<MainPagesManager> createState() => _MainPagesManagerState();
}

class _MainPagesManagerState extends State<MainPagesManager> {
  late int _selectedIndex;
  late String _appBarTitle;
  final AuthService _auth = AuthService();

  late List<Widget> _widgetOptions;
  late List<String> _titles;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _appBarTitle = _titles[_selectedIndex];
    _initWidgetOptions();
  }

  void _initWidgetOptions() {
    _widgetOptions = <Widget>[
      const JournalFeed(),
      const PlantFeed(),
      GartenfreundePage(key: UniqueKey()), // Add a unique key
    ];

    _titles = [
      'SproutJournal 🌱',
      'SproutJournal 🌱',
      'Gartenfreunde 🌱',
    ];
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
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
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
              onPressed: () async {
                Object? followStatusChanged = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GartenfreundeUserSearch(
                      user: user,
                    ),
                  ),
                );
                if (followStatusChanged != null) {
                  Log().d("Follow status has changed");
                  setState(() {
                    // Refresh the feed by updating the key
                    _widgetOptions[2] = GartenfreundePage(key: UniqueKey());
                    _selectedIndex = 2;
                  });
                }
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
