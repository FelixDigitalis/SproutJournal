import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class JournalEntryElement extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onDelete;

  const JournalEntryElement({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry['text'] != null)
              Text(entry['text'],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary)),
            if (entry['photoPath'] != null)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.file(File(entry['photoPath'])),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text('Schließen'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: FutureBuilder<bool>(
                  future: _isImageVertical(entry['photoPath']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: const Icon(Icons.error),
                      );
                    } else {
                      final isVertical = snapshot.data ?? false;
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        constraints: isVertical
                            ? const BoxConstraints(maxWidth: 200)
                            : const BoxConstraints(),
                        child: Image.file(
                          File(entry['photoPath']),
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
            Text(entry['date'],
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary)),
          ],
        ),
        onLongPress: onDelete,
      ),
    );
  }

  Future<bool> _isImageVertical(String path) async {
    final bytes = await File(path).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image != null) {
      return image.height > image.width;
    }
    return false;
  }
}
