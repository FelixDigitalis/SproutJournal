import 'package:flutter/material.dart';
import 'package:sprout_journal/database_services/sqllite/inventory_manager.dart';
import '../../models/plant_model.dart';
import '../../database_services/sqllite/journal_entry_manager.dart';
import '../elements/plant_journal/journal_poster_element.dart';
import '../elements/plant_journal/journal_plant_header.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import '../../../utils/log.dart';

class JournalEntryPage extends StatefulWidget {
  final Plant plant;
  final Map<String, dynamic> plantFromManager;

  const JournalEntryPage({
    super.key,
    required this.plant,
    required this.plantFromManager,
  });

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  late TextEditingController _dateController;
  late TextEditingController _postController;
  late String plantingDate;
  late int plantID;
  late int dbUUID;
  late bool hasDateBeenUpdated;
  List<Map<String, dynamic>> _journalEntries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController =
        TextEditingController(text: widget.plantFromManager['plantingDate']);
    _postController = TextEditingController();
    plantingDate = widget.plantFromManager['plantingDate'];
    plantID = widget.plantFromManager['plantID'];
    dbUUID = widget.plantFromManager['id'];
    hasDateBeenUpdated = false;
    _fetchJournalEntries();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // https://docs.flutter.dev/release/breaking-changes/android-predictive-back
      canPop: false,
      onPopInvoked: (bool hasPoped) {
        if (!hasPoped) {
          hasPoped = true;
          Navigator.pop(context, hasDateBeenUpdated);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              JournalPlantHeader(
                plant: widget.plant,
                dateController: _dateController,
                plantingDate: plantingDate,
                dbUUID: dbUUID,
                onDateChanged: _updatePlantingDate,
              ),
              JournalPosterElement(
                postController: _postController,
                plantID: plantID,
                uuid: dbUUID,
                fetchJournalEntries: _refreshJournalEntries,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildJournalEntriesList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchJournalEntries() async {
    setState(() {
      _isLoading = true;
    });

    final entries = await JournalEntryManager.instance
        .getAllJournalEntries();

    setState(() {
      _isLoading = false;
      _journalEntries = entries
          .where((entry) => entry['journalManagerID'] == plantID)
          .toList();
    });
  }

  Future<void> _refreshJournalEntries() async {
    setState(() {
      _journalEntries.clear();
      _isLoading = false;
    });
    _fetchJournalEntries();
  }

  void _updatePlantingDate(String newDate) {
    hasDateBeenUpdated = true;
    setState(() {
      plantingDate = newDate;
    });
  }

  void _showDeleteDialog(
      BuildContext context, Map<String, dynamic> entry, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            'Eintrag löschen?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Abbrechen',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  JournalEntryManager.instance.deleteJournalEntry(entry['id']);
                  _journalEntries.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Löschen',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
        onPressed: () {
          Navigator.pop(context, hasDateBeenUpdated);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            _showDeletePlantDialog(context);
          },
        ),
      ],
    );
  }

  void _showDeletePlantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            'Planze löschen?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          content: Text(
            'Die Pflanze wird endgültig aus Deinem Inventar gelöscht. Dies kann nicht Rückgängig gemacht werden.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Abbrechen',
                style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                InventoryManager.instance.deletePlant(dbUUID);
                Navigator.pop(context, true);
              },
              child: const Text(
                'Löschen',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildJournalEntriesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _journalEntries.length,
        itemBuilder: (context, index) {
          final entry = _journalEntries[index];
          return _buildJournalEntryElement(entry, index);
        },
      ),
    );
  }

  Widget _buildJournalEntryElement(Map<String, dynamic> entry, int index) {
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
        onLongPress: () => _showDeleteDialog(context, entry, index),
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
