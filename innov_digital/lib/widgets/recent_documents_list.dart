import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:innov_digital/utils/time_formatter.dart';
import 'package:innov_digital/widgets/document_card.dart';
import 'package:innov_digital/widgets/Bottom_NavBar.dart'; // Assuming you have this widget

class RecentDocumentsPage extends StatefulWidget {
  const RecentDocumentsPage({super.key});

  @override
  _RecentDocumentsPageState createState() => _RecentDocumentsPageState();
}

class _RecentDocumentsPageState extends State<RecentDocumentsPage> {
  List<Map<String, dynamic>> documents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch documents when the page is initialized
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/toutavoir'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, dynamic>> parsedDocs = data.map((doc) {
          final List<dynamic> versions = doc['versions'];
          final lastUploadTime = versions.isNotEmpty
              ? DateTime.parse(versions.last['uploaded_at'])
              : DateTime.parse(doc['uploaded_at']);
          return {
            'docType': getDocumentType(doc['filename']),
            'title': doc['filename'],
            'lastModified': formatTimeAgo(lastUploadTime),
            'keywords': (doc['keywords'] as String)
                .split(',')
                .map((s) => s.trim())
                .toList(),
            'content': doc['extracted_text'] ?? "No content available",
            'uploadedBy': doc['uploader'],
            'uploadedAt': DateTime.parse(doc['uploaded_at']),
            'history': versions.map((v) {
              return {
                'action': 'Version ${v['version_number']}',
                'timestamp': DateTime.parse(v['uploaded_at']),
              };
            }).toList(),
          };
        }).toList();

        setState(() {
          documents = parsedDocs;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load documents');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getDocumentType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    if (['mp3', 'mp4', 'avi'].contains(ext)) {
      return 'audio';
    } else if (['png', 'jpg', 'jpeg'].contains(ext)) {
      return 'image';
    } else {
      return 'texte';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Stack(
        children: [
          documents.isEmpty
              ? const Center(child: Text("No recent documents available."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return DocumentCard(
                      docType: doc['docType'],
                      title: doc['title'],
                      lastModified: doc['lastModified'],
                      keywords: doc['keywords'],
                      content: doc['content'],
                      uploadedBy: doc['uploadedBy'],
                      uploadedAt: doc['uploadedAt'],
                      history: doc['history'],
                    );
                  },
                ),
          if (isLoading)
            Container(
              color: const Color.fromARGB(255, 117, 110, 110),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
