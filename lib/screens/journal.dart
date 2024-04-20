import 'package:flutter/material.dart';
import 'elements/bottom_bar.dart';
import 'settings.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});
  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Journal Page'),
    Text('Pflanzen Page'),
    Text('Gartenfreunde Page'),
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
        title: const Text('SproutJournal 🌱'),
        backgroundColor: Colors.green,
        // Settings Menu
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsMenu()),
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
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
