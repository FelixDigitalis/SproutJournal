import 'package:flutter/material.dart';
import '../../../services/journal_entry_manager.dart';
import '../../../utils/log.dart';

class JournalPosterElement extends StatefulWidget {
  final TextEditingController postController;
  final int plantID;
  final VoidCallback fetchJournalEntries;

  const JournalPosterElement({
    super.key,
    required this.postController,
    required this.plantID,
    required this.fetchJournalEntries,
  });

  @override
  JournalPosterElementState createState() => JournalPosterElementState();
}

class JournalPosterElementState extends State<JournalPosterElement> {
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
          Column(
            children: [
              FloatingActionButton(
                onPressed: _addJournalEntry,
                child: const Icon(Icons.book),
              ),
            ],
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
}
