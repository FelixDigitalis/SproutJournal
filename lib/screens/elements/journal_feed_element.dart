import 'package:flutter/material.dart';
import 'package:sprout_journal/models/plant_model.dart';
import '../sub_pages/journal_entry_page.dart';
import 'package:sprout_journal/utils/log.dart';

class JournalFeedElement extends StatefulWidget {
  final Plant plant;
  final Map<String, dynamic> plantFromManager;
  final Function refreshFeed;

  const JournalFeedElement({
    super.key,
    required this.plant,
    required this.plantFromManager,
    required this.refreshFeed,
  });

  @override
  JournalFeedElementState createState() => JournalFeedElementState();
}

class JournalFeedElementState extends State<JournalFeedElement> {
  late String _plantingDate;

  @override
  void initState() {
    super.initState();
    _plantingDate = widget.plantFromManager['plantingDate'];
  }

  @override
  Widget build(BuildContext context) {
    String imagePath =
        "assets/images/plants/${widget.plant.englishName.toLowerCase()}.png";

    return InkWell(
      onTap: () async {
        bool hasDateBeenUpdated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalEntryPage(
              plant: widget.plant,
              plantFromManager: widget.plantFromManager,
            ),
          ),
        );
        Log().d(hasDateBeenUpdated.toString());

        if (hasDateBeenUpdated) {
          widget.refreshFeed();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(0), 
                      child: Image.asset(
                        imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plant.germanName,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'gepflanzt am: $_plantingDate',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
