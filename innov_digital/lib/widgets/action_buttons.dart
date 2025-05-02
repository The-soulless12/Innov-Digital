import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'action_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  void _showAddDocumentDialog(BuildContext context) {
    XFile? selectedFile;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Add Document'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose File'),
                  onPressed: () async {
                    final XFile? file = await openFile();

                    if (file != null) {
                      setState(() {
                        selectedFile = file;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (selectedFile != null)
                  Text(
                    path.basename(selectedFile!.path),
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: selectedFile == null
                    ? null
                    : () async {
                        final uri = Uri.parse('https://your-backend.com/upload');

                        var request = http.MultipartRequest('POST', uri)
                          ..files.add(await http.MultipartFile.fromPath(
                            'file',
                            selectedFile!.path,
                          ));

                        var response = await request.send();

                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upload successful!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upload failed.')),
                          );
                        }
                      },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: Icons.add,
            label: 'Add Document',
            onPressed: () => _showAddDocumentDialog(context),
          ),
          ActionButton(
            icon: Icons.history,
            label: 'History',
            onPressed: () {
              // Add action for history
            },
          ),
        ],
      ),
    );
  }
}
