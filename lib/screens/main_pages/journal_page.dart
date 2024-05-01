import 'package:flutter/material.dart';
import '../../services/inventory_manager.dart';
import '../../models/plant_model.dart';
import '../../services/json_manager.dart';
import '../../services/log.dart';
import '../elements/journal_plant_element.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPlants(), // Directly calling fetchPlants() here
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
              return FutureBuilder<Plant?>(
                future: JsonManager().getPlantById(plantId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return JournalPlantElement(plant: snapshot.data!);
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
          return Center(
            child: Text(
              'Bisher keine Pflanzen im Journal',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchPlants() async {
    try {
      List<Map<String, dynamic>> plants =
          await InventoryManager.instance.getAllPlants();
      return plants;
    } catch (e) {
      Log().e('No plants: $e');
      return <Map<String, dynamic>>[];
    }
  }
}
