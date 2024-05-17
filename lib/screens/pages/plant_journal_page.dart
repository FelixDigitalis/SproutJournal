import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/plant_model.dart';
import '../../services/inventory_manager.dart';
import '../../services/journal_entry_manager.dart';

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
  List<Map<String, dynamic>> _journalEntries = [];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.plantFromManager['plantingDate'],
    );
    _postController = TextEditingController();
    plantingDate = widget.plantFromManager['plantingDate'];
    plantID = widget.plantFromManager['plantID'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plant.germanName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Implement delete plant
              }),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/images/plants/${widget.plant.englishName.toLowerCase()}.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.plant.germanName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Gepflanzt am',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _changeDate(context),
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
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
                  FloatingActionButton(
                    onPressed: _addJournalEntry,
                    child: const Icon(Icons.book),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _journalEntries.length,
                itemBuilder: (context, index) {
                  final entry = _journalEntries[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(entry['text'],
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onSecondary)),
                      subtitle: Text(entry['date'],
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onSecondary)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        onPressed: () {
                          setState(() {
                            JournalEntryManager.instance
                                .deleteJournalEntry(entry['id']);
                            _journalEntries.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd.MM.yyyy').parse(plantingDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      final displayDate = DateFormat('dd.MM.yyyy').format(picked);
      plantingDate = displayDate;
      int state = await InventoryManager.instance
          .updatePlantingDate(plantID, formattedDate);

      if (state == 1) {
        setState(() {
          _dateController.text = displayDate;
        });
      }
    }
  }

  Future<void> _addJournalEntry() async {
    if (_postController.text.isNotEmpty) {
      await JournalEntryManager.instance.addJournalEntry(
        plantID,
        _postController.text,
      );
      _postController.clear();
      _fetchJournalEntries();
    }
  }

  Future<void> _fetchJournalEntries() async {
    final entries = await JournalEntryManager.instance.getAllJournalEntries();
    setState(() {
      _journalEntries = entries
          .where((entry) => entry['journalManagerID'] == plantID)
          .toList();
    });
  }
}
