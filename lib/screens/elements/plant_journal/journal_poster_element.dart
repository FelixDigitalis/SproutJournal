import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.postController,
                  decoration: InputDecoration(
                    labelText: 'Neuer Eintrag',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
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
                    await _takePhoto();
                  } else if (value == 1) {
                    await _addPhotoFromDevice();
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
          const SizedBox(height: 10),
          if (_selectedImagePath != null)
            Column(
              children: [
                Image.file(
                  File(_selectedImagePath!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _popImageFromPreview,
                  child: const Text('Bild entfernen'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _addJournalEntry() async {
    Log().i('Adding journal entry');
    if (widget.postController.text.isNotEmpty || _selectedImagePath != null) {
      if (_selectedImagePath != null) {
        await JournalEntryManager.instance.addJournalEntry(
          widget.plantID,
          widget.postController.text,
          photoPath: _selectedImagePath,
        );
        _popImageFromPreview();
      } else {
        await JournalEntryManager.instance.addJournalEntry(
          widget.plantID,
          widget.postController.text,
        );
      }
      widget.postController.clear();
      widget.fetchJournalEntries();
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final compressedImage = await _compressImage(File(photo.path));
      setState(() {
        _selectedImagePath = compressedImage.path;
      });
    }
  }

  Future<void> _addPhotoFromDevice() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final compressedImage = await _compressImage(File(photo.path));
      setState(() {
        _selectedImagePath = compressedImage.path;
      });
    }
  }

  Future<File> _compressImage(File file) async {
    final compressedImagePath = file.path.replaceAll('.jpg', '.jpg');
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      compressedImagePath,
      quality: 90, 
    );
    return compressedImage ?? file;
  }

  void _popImageFromPreview() {
    setState(() {
      _selectedImagePath = null;
    });
  }
}
