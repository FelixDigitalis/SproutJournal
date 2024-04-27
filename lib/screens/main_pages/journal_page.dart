import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Bisher keine Pflanzen im Journal', style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
    );
  }
}
