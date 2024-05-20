import 'dart:io';
import 'package:flutter/material.dart';

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
        title: Text(entry['text'],
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry['photoPath'] != null)
              Image.file(
                File(entry['photoPath']),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
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
}
