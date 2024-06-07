import 'package:flutter/material.dart';

class HintPage extends StatelessWidget {
  final VoidCallback onDismiss;

  HintPage({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tipps', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Schließen',
            onPressed: onDismiss,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHintItem(context, Icons.book, 'Journal', RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hier findest du alle Pflanzen, die du deinem Journal hinzugefügt hast. Mit einem Klick auf das Profil kannst du den Wachstumsverlauf deiner Pflanze mit Text und Bildern dokumentieren.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 10),
            _buildHintItem(context, Icons.local_florist, 'Pflanzen', RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Hier findest du vorgefertigte Pflanzprofile und Tipps. Mit einem Klick auf das Profil kannst du mit dem ',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.add, color: Colors.black, size: 16),
                  ),
                  TextSpan(
                    text: '-Button die Pflanze in dein Journal hinzufügen.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 10),
            _buildHintItem(context, Icons.people, 'Gartenfreunde', RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Verbinde dich mit anderen Gärtnern. Melde dich mit deiner E-Mail und einem Nicknamen an, folge anderen Gärtnern unter der ',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.search, color: Colors.black, size: 16),
                  ),
                  TextSpan(
                    text: ' und teile deine Erfahrungen.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            _buildHintItem(context, Icons.settings, 'Einstellungen', RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Falls du die Tipps noch einmal brauchst, kannst du sie jederzeit in den ',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  WidgetSpan(
                    child: Icon(Icons.settings, color: Colors.black, size: 16),
                  ),
                  TextSpan(
                    text: ' wieder aufrufen.',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            )),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: onDismiss,
                child: const Text('Verstanden'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintItem(BuildContext context, IconData icon, String title, Widget description) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              description,
            ],
          ),
        ),
      ],
    );
  }
}
