import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/journal_entry_manager.dart';
import '../../../utils/log.dart';

class JournalPosterElement extends StatefulWidget {
  final TextEditingController postController;
  final int plantID;
  final VoidCallback fetchJournalEntries;
  final int uuid;

  const JournalPosterElement({
    super.key,
    required this.postController,
    required this.plantID,
    required this.fetchJournalEntries,
    required this.uuid,
  });

  @override
  JournalPosterElementState createState() => JournalPosterElementState();
}

class JournalPosterElementState extends State<JournalPosterElement> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.postController,
              decoration: InputDecoration(
                labelText: 'Neuer Journal Eintrag',
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<int>(
            icon: const Icon(Icons.photo_camera),
            onSelected: (value) async {
              if (value == 0) {
                _takePhoto();
              } else if (value == 1) {
                _addPhotoFromDevice();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('Foto aufnehmen'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 8),
                    Text('Foto vom Gerät'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _addJournalEntry,
            child: const Icon(Icons.book),
          ),
        ],
      ),
    );
  }

  Future<void> _addJournalEntry() async {
    Log().i('Adding journal entry');
    if (widget.postController.text.isNotEmpty) {
      await JournalEntryManager.instance.addJournalEntry(
        widget.plantID,
        widget.postController.text,
      );
      widget.postController.clear();
      widget.fetchJournalEntries();
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Log().i('Photo taken: ${photo.path}');
      await JournalEntryManager.instance.addPhotoPathToJournalEntry(
        widget.uuid,
        photo.path,
      );
      widget.fetchJournalEntries();
    }
  }

  Future<void> _addPhotoFromDevice() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      Log().i('Photo picked from device: ${photo.path}');
      await JournalEntryManager.instance.addPhotoPathToJournalEntry(
        widget.uuid,
        photo.path,
      );
      widget.fetchJournalEntries();
    }
  }
}
