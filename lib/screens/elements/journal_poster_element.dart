// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../services/journal_entry_manager.dart';

class JournalPosterElement extends StatelessWidget {
  final TextEditingController postController;
  final int plantID;

  const JournalPosterElement({
    super.key,
    required this.postController,
    required this.plantID,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: postController,
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
    if (postController.text.isNotEmpty) {
      await JournalEntryManager.instance.addJournalEntry(
        plantID,
        postController.text,
      );
      postController.clear();
    }
  }
}
