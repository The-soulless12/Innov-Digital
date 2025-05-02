import 'package:flutter/material.dart';

class RecentDocumentsList extends StatelessWidget {
  const RecentDocumentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text('Document ${index + 1}'),
            subtitle: const Text('Modified yesterday'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}
