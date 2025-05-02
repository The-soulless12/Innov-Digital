import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentCard extends StatelessWidget {
  final String docType; // "texte", "audio", "image"
  final String title;
  final String author;
  final String lastModified;

  const DocumentCard({
    super.key,
    required this.docType,
    required this.title,
    required this.author,
    required this.lastModified,
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SvgPicture.asset(
          _getAssetForType(docType),
          width: 32,
          height: 32,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Text(lastModified, style: Theme.of(context).textTheme.bodySmall),
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
                  author,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
