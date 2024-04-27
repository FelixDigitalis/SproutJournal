import 'package:flutter/material.dart';
import 'package:sprout_journal/screens/elements/plant_library_element.dart';
import '../../services/plant_manager.dart';
import '../../models/plant_model.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late Future<List<Plant>> _plants;

  @override
  void initState() {
    super.initState();
    _plants = PlantManager().loadPlants(); // Load plants on init
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Plant plant = snapshot.data![index];
                  return PlantLibElement(plant: plant);
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
