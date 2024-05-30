import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../../../utils/log.dart';

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
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: FutureBuilder<File>(
                  future: _loadImage(entry['photoPath']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300], 
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      Log().e('Error loading image: ${snapshot.error}');
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final imageFile = snapshot.data!;
                      return FutureBuilder<bool>(
                        future: _isImageVertical(imageFile.path),
                        builder: (context, orientationSnapshot) {
                          if (orientationSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              child: const CircularProgressIndicator(),
                            );
                          } else if (orientationSnapshot.hasError) {
                            Log().e(
                                'Error determining image orientation: ${orientationSnapshot.error}');
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              child: const Icon(Icons.error),
                            );
                          } else {
                            final isVertical =
                                orientationSnapshot.data ?? false;
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              constraints: isVertical
                                  ? const BoxConstraints(maxWidth: 200)
                                  : const BoxConstraints(),
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
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
    try {
      final bytes = await File(path).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        return image.height > image.width;
      } else {
        throw Exception('Unable to decode image');
      }
    } catch (e) {
      Log().e('Error in _isImageVertical: $e');
      return false;
    }
  }

  Future<File> _loadImage(String path) async {
    try {
      final file = File(path);
      return file;
    } catch (e) {
      Log().e('Error in _loadImage: $e');
      rethrow;
    }
  }
}
