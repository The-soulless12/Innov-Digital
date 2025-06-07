import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.context,
  });

  void _navigateTo(int index) {
    if (index == currentIndex) return; // No-op if same screen

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');

        break;
      case 1:
        Navigator.pushNamed(context, '/documents');

        break;
      case 2:
        Navigator.pushNamed(context, '/profile');

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _navigateTo,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Documents'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
