import 'package:flutter/material.dart';
import 'package:sprout_journal/database_services/sqllite/inventory_manager.dart';
import '../../models/plant_model.dart';
import '../../database_services/sqllite/journal_entry_manager.dart';
import '../elements/plant_journal/journal_entry_element.dart';
import '../elements/plant_journal/journal_poster_element.dart';
import '../elements/plant_journal/journal_plant_header.dart';
// import 'package:sprout_journal/utils/log.dart';

class PlantJournalPage extends StatefulWidget {
  final Plant plant;
  final Map<String, dynamic> plantFromManager;

  const PlantJournalPage({
    super.key,
    required this.plant,
    required this.plantFromManager,
  });

  @override
  PlantJournalPageState createState() => PlantJournalPageState();
}

class PlantJournalPageState extends State<PlantJournalPage> {
  late TextEditingController _dateController;
  late TextEditingController _postController;
  late String plantingDate;
  late int plantID;
  late int dbUUID;
  late bool hasDateBeenUpdated;
  List<Map<String, dynamic>> _journalEntries = [];

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
                fetchJournalEntries: _fetchJournalEntries,
              ),
              const SizedBox(height: 20),
              _buildJournalEntriesList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchJournalEntries() async {
    final entries = await JournalEntryManager.instance.getAllJournalEntries();
    setState(() {
      _journalEntries = entries
          .where((entry) => entry['journalManagerID'] == plantID)
          .toList();
    });
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
      actions: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // InventoryManager.instance.deletePlant(dbUUID);
              _showDeletePlantDialog(context);
              // Navigator.pop(context, true);
            }),
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
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
          return JournalEntryElement(
            entry: entry,
            onDelete: () {
              _showDeleteDialog(context, entry, index);
            },
          );
        },
      ),
    );
  }
}
