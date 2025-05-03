import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innov_digital/utils/time_formatter.dart';
import 'dart:convert';

import '../widgets/document_card.dart';
import '../main.dart'; // import where routeObserver is defined
import 'package:innov_digital/widgets/Bottom_NavBar.dart';

class AllDocumentsPage extends StatefulWidget {
  const AllDocumentsPage({super.key});

  @override
  State<AllDocumentsPage> createState() => _AllDocumentsPageState();
}

class _AllDocumentsPageState extends State<AllDocumentsPage> with RouteAware {
  List<Map<String, dynamic>> documents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when returning to this screen
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    setState(() => isLoading = true);

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
            'docType': 'texte',
            'title': doc['filename'],
            'lastModified': formatTimeAgo(lastUploadTime),
            'keywords': (doc['keywords'] as List<dynamic>).cast<String>(),
            'content': doc['extracted_text'] ?? 'No content',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Documents"),
        backgroundColor: const Color(0xFF5B2682),
      ),
      body: Stack(
  children: [
    documents.isEmpty
        ? const Center(child: Text("No documents available."))
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
        color: const Color.fromARGB(255, 117, 110, 110), // Optional semi-transparent overlay
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
),
      bottomNavigationBar: BottomNavBar(currentIndex: 1, context: context),
    );
  }
}
