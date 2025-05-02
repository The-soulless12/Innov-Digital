import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/ai_search_bar.dart';
import '../widgets/recent_documents_list.dart';
import '../widgets/action_buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
  const TopBar(),
  const SizedBox(height: 20),
  const AISearchBar(),
  const SizedBox(height: 20),
  const Text(
    'Recent Documents',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  ),
  const SizedBox(height: 10),
  const Expanded(child: RecentDocumentsList()),
  ActionButtons(), // <- non-const
],

          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Documents'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
