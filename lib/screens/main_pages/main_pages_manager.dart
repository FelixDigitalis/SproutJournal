import 'package:flutter/material.dart';
import '../elements/bottom_bar_element.dart';
import '../pages/settings_page.dart';
import 'friends_page.dart';
import 'journal_page.dart';
import 'library_page.dart';

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
                fontSize: 24,
                fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              // Navigate to the SettingsMenu page when the icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsMenu()),
              );
            },
          )
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
