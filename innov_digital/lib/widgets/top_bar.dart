import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Hello, Tarek 👋',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Row(
          children: const [
            Icon(Icons.notifications_none, size: 28),
            SizedBox(width: 16),
            Icon(Icons.person, size: 28),
            //CircleAvatar(
              //radius: 18,
              //backgroundImage: AssetImage('assets/profile.jpg'),
            //),
          ],
        ),
      ],
    );
  }
}
