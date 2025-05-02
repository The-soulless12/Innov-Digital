import 'package:flutter/material.dart';
import 'document_card.dart'; // Import your DocumentCard widget
import '/utils/time_formatter.dart';
class RecentDocumentsList extends StatelessWidget {
  const RecentDocumentsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample documents list with necessary fields
    final docs = [
      {
        'type': 'texte',
        'title': 'Compte rendu',
        'author': 'Alice',
        'modified': 'Aujourd\'hui',
        'keywords': ['rapport', 'réunion'],
        'content': 'Contenu du compte rendu...',
        'uploadedBy': 'Alice',
        'uploadedAt': DateTime.now(),
        'history': [
          {'action': 'uploaded', 'timestamp': DateTime.now()},
        ],
      },
      {
        'type': 'audio',
        'title': 'Interview Radio',
        'author': 'Bob',
        'modified': 'Hier',
        'keywords': ['interview', 'radio'],
        'content': 'Contenu de l\'interview...',
        'uploadedBy': 'Bob',
        'uploadedAt': DateTime.now(),
        'history': [
          {'action': 'uploaded', 'timestamp': DateTime.now()},
        ],
      },
      {
        'type': 'image',
        'title': 'Scan Ordonnance',
        'author': 'Carla',
        'modified': 'Il y a 2 jours',
        'keywords': ['ordonnance', 'scan'],
        'content': 'Contenu de l\'ordonnance...',
        'uploadedBy': 'Carla',
        'uploadedAt': DateTime.now(),
        'history': [
          {'action': 'uploaded', 'timestamp': DateTime.now()},
        ],
      },
    ];

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return DocumentCard(
          docType: doc['type'] as String, // Cast to String
          title: doc['title'] as String, // Cast to String
          author: doc['author'] as String, // Cast to String
          lastModified: formatTimeAgo(
  (doc['history'] as List).last['timestamp'] as DateTime,
),

          keywords: List<String>.from(doc['keywords'] as List), // Cast to List<String>
          content: doc['content'] as String, // Cast to String
          uploadedBy: doc['uploadedBy'] as String, // Cast to String
          uploadedAt: doc['uploadedAt'] as DateTime, // Cast to DateTime
          history: List<Map<String, dynamic>>.from(doc['history'] as List), // Cast to List<Map<String, dynamic>>
        );
      },
    );
  }
}
