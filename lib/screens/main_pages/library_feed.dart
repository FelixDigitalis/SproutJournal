import 'package:flutter/material.dart';
import 'package:sprout_journal/screens/elements/library_plant_element.dart';
import '../../database_services/json_manager.dart';
import '../../models/plant_model.dart';

class PlantFeed extends StatefulWidget {
  const PlantFeed({super.key});

  @override
  State<PlantFeed> createState() => _PlantFeedState();
}

class _PlantFeedState extends State<PlantFeed> {
  late Future<List<Plant>> _plants;

  @override
  void initState() {
    super.initState();
    _plants = JsonManager().loadPlants(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Plant>>(
        future: _plants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  childAspectRatio: 1.0, 
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Plant plant = snapshot.data![index];
                  return LibraryPlantElement(plant: plant);
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
