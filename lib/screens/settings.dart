import 'package:flutter/material.dart';


class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});
  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen 🌱'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Über'),
            subtitle: const Text(
                'SproutJournal, ein App Projekt von Felix im Sommersemester 2024'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
