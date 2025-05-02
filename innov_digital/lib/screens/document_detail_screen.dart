import 'package:flutter/material.dart';
class DocumentDetailPage extends StatelessWidget {
  final String docType;
  final String title;
  final String author;
  final String lastModified;

  const DocumentDetailPage({
    super.key,
    required this.docType,
    required this.title,
    required this.author,
    required this.lastModified,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: $title', style: Theme.of(context).textTheme.titleLarge),
            Text('Author: $author'),
            Text('Last Modified: $lastModified'),
            Text('Type: $docType'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to open or edit the document
              },
              child: const Text('Edit Document'),
            ),
          ],
        ),
      ),
    );
  }
}
