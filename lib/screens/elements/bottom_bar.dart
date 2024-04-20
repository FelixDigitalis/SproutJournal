// navigation_bar.dart
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: 'Pflanzen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Gartenfreunde',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      onTap: onItemTapped,
    );
  }
}
