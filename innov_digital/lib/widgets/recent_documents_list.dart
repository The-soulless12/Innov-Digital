import 'package:flutter/material.dart';
import 'document_card.dart'; // importe ton widget

class RecentDocumentsList extends StatelessWidget {
  const RecentDocumentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = [
      {'type': 'texte', 'title': 'Compte rendu', 'author': 'Alice', 'modified': 'Aujourd\'hui'},
      {'type': 'audio', 'title': 'Interview Radio', 'author': 'Bob', 'modified': 'Hier'},
      {'type': 'image', 'title': 'Scan Ordonnance', 'author': 'Carla', 'modified': 'Il y a 2 jours'},
    ];

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return DocumentCard(
          docType: doc['type']!,
          title: doc['title']!,
          author: doc['author']!,
          lastModified: doc['modified']!,
        );
      },
    );
  }
}
