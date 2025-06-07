import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/document_detail_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class DocumentCard extends StatelessWidget {
  final String docType; // "texte", "audio", "image"
  final String title;
  final String lastModified;
  final List<String> keywords; // List of keywords to pass to the details page
  final String content; // Content of the document
  final String uploadedBy; // The uploader's name
  final DateTime uploadedAt; // The upload timestamp
  final List<Map<String, dynamic>>
  history; // The history of actions on the document

  const DocumentCard({
    super.key,
    required this.docType, //extension
    required this.title,
    required this.lastModified, //men history
    required this.keywords,
    required this.content,
    required this.uploadedBy, //uploader
    required this.uploadedAt, //upload timestamp
    required this.history,
  });

  String _getAssetForType(String type) {
    switch (type.toLowerCase()) {
      case 'texte':
        return 'assets/text.svg';
      case 'audio':
        return 'assets/audio.svg';
      case 'image':
        return 'assets/image.svg';
      default:
        return 'assets/text.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to DocumentDetailPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => DocumentDetailPage(
                    docType: docType,
                    title: title,
                    lastModified: lastModified,
                    keywords: keywords,
                    content: content,
                    uploadedBy: uploadedBy,
                    uploadedAt: uploadedAt,
                    history: history,
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading Icon
              SvgPicture.asset(
                _getAssetForType(docType),
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 12),

              // Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          lastModified,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset(
                          'assets/CircleFill.svg',
                          width: 6,
                          height: 6,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            uploadedBy,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Robo Button
              IconButton(
                icon: SvgPicture.asset(
                  'assets/robo.svg',
                  width: 24,
                  height: 24,
                ),
                 onPressed: () async {
    final player = AudioPlayer();
    await player.play(AssetSource('assets/sound.mp3'));
  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
