import 'package:flutter/material.dart';
import 'elements/bottom_bar_element.dart';
import 'settings.dart';
import 'pages/friends_page.dart';
import 'pages/journal_page.dart';
import 'pages/plant_page.dart';

class PageManager extends StatefulWidget {
  const PageManager({super.key});
  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const JournalPage(),
    const PlantPage(),
    const FriendsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SproutJournal 🌱',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.green[800],
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsMenu()),
                  );
                  break;
              }
            },
            // Settings Menu Pop up menu
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
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
