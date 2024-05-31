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
        title: const Text('Einstellungen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Über',
                style: TextStyle(
                  color: Colors.black,
                )),
            subtitle: const Text(
                'SproutJournal, ein App Projekt von Felix im Sommersemester 2024',
                style: TextStyle(
                  color: Colors.black,
                )),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
