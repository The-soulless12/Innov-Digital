import 'package:flutter/material.dart';
import '../widgets/press_chip.dart';

class DocumentDetailPage extends StatelessWidget {
  final String docType;
  final String title;
  final String author;
  final String lastModified;
  final List<String> keywords; // List of keywords (to be displayed as chips)
  final String content; // The content of the document
  final String uploadedBy; // The author (same as the uploaded_by field in the backend)
  final DateTime uploadedAt; // The timestamp of when the document was uploaded
  final List<Map<String, dynamic>> history; // The history of actions on the document

  const DocumentDetailPage({
    super.key,
    required this.docType,
    required this.title,
    required this.author,
    required this.lastModified,
    required this.keywords,
    required this.content,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Details'),
        backgroundColor: const Color(0xFF5B2682), // Using a custom color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Document Info'),
              const SizedBox(height: 10),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Title', title),
                    _buildInfoRow('Author', author),
                    _buildInfoRow('Last Modified', lastModified),
                    _buildInfoRow('Type', docType),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('Keywords'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0, // horizontal space between chips
                runSpacing: 4.0, // vertical space between chips
                children: keywords.map((keyword) => PressChip(label: keyword)).toList(),
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('Content'),
              const SizedBox(height: 10),
              _buildCard(child: Text(content)),

              const SizedBox(height: 20),

              _buildSectionTitle('Uploaded By'),
              const SizedBox(height: 10),
              _buildCard(child: Text(uploadedBy)),

              const SizedBox(height: 20),

              _buildSectionTitle('Upload Date'),
              const SizedBox(height: 10),
              _buildCard(child: Text(uploadedAt.toLocal().toString())),

              const SizedBox(height: 20),

              _buildSectionTitle('Document History'),
              const SizedBox(height: 10),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: history.map((action) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('Action: ${action['action']} at ${action['timestamp']}'),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add logic to open or edit the document
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B2682), // Corrected color parameter
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Edit Document'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF5B2682),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
