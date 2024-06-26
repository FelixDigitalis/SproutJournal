import 'package:flutter/material.dart';
import '../../database_services/sqllite/inventory_manager.dart';
import '../../models/plant_model.dart';
import '../../database_services/json_manager.dart';
import '../../utils/log.dart';
import '../elements/journal_feed_element.dart';

class JournalFeed extends StatefulWidget {
  const JournalFeed({super.key});

  @override
  JournalFeedState createState() => JournalFeedState();
}

class JournalFeedState extends State<JournalFeed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPlants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading plants',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              var plantId = plants[index]['plantID'];
              Map<String, dynamic> plantFromManager = plants[index];
              return FutureBuilder<Plant?>(
                future: JsonManager().getPlantById(plantId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return JournalFeedElement(
                        plant: snapshot.data!,
                        plantFromManager: plantFromManager,
                        refreshFeed : _refreshFeed,
                      );
                    } else {
                      return const ListTile(
                        title: Text('Plant not found'),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              'Bisher keine Pflanzen im Journal',
              style:
                  TextStyle(color: Colors.black),
            ),
          );
        }
      },
    );
  }

  Future<void> _refreshFeed() async {
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchPlants() async {
    try {
      // await InventoryManager.instance.deleteAll();
      List<Map<String, dynamic>> plants =
          await InventoryManager.instance.getAllPlants();
      return plants;
    } catch (e) {
      Log().e('No plants: $e');
      return <Map<String, dynamic>>[];
    }
  }
}
