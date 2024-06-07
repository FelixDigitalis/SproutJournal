// navigation_bar.dart
import 'package:flutter/material.dart';

class BottomBarElement extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBarElement({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        _buildBottomNavigationBarItem(
          icon: Icons.book,
          label: 'Journal',
          context: context,
          index: 0,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.local_florist,
          label: 'Pflanzen',
          context: context,
          index: 1,
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.people,
          label: 'Gartenfreunde',
          context: context,
          index: 2,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.white,
      onTap: onItemTapped,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required BuildContext context,
    required int index,
  }) {
    final bool isSelected = index == selectedIndex;
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
            ),
          Icon(icon),
        ],
      ),
      label: label,
    );
  }
}
