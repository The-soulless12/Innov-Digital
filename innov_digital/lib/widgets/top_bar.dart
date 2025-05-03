import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          'assets/logo_Indexia.svg',
          height: 35, // adjust as needed
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
