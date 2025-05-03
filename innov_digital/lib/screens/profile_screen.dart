import 'package:flutter/material.dart';
import 'package:innov_digital/widgets/Bottom_NavBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF5B2682),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text("Tarek Benameur", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("lt_benameur@esi.dz", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            Text("Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change Password"),
              onTap: null, // à implémenter
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: null, // à implémenter
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2,context: context,),
    );
  }
}
