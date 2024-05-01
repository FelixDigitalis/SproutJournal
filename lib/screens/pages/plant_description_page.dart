import 'package:flutter/material.dart';
import '../../models/plant_model.dart';
import '../../services/inventory_manager.dart';

class PlantDescriptionPage extends StatelessWidget {
  final Plant plant;

  const PlantDescriptionPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.germanName,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                      'Ausaat: ${_formatSowingRange(plant.minSowBy, plant.maxSowBy)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  Text(
                      'Saattiefe: ${_formatDepthRange(plant.sowingDepthMin, plant.sowingDepthMax)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  Text(
                      'Keimtemperatur: ${_formatTemperatureRange(plant.germinationTemperatureMin, plant.germinationTemperatureMax)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 10),
                  Text(
                      'Keimdauer: ${_formatDurationRange(plant.germinationDurationMin, plant.germinationDurationMax)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: RawMaterialButton(
                onPressed: () => _showAddPlantDialog(context),
                elevation: 2.0,
                fillColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  void _showAddPlantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pflanze hinzufügen", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          content:  Text("Möchten Sie diese Pflanze zum Inventar hinzufügen?", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                InventoryManager.instance.addPlantToInventory(plant.id, "foo");
                Navigator.of(context).pop(); 
              },
              child: const Text('Ja'),
            ),
          ],
        );
      },
    );
  }


  String _formatSowingRange(int minMonth, int maxMonth) {
    if (minMonth == maxMonth) {
      return 'im ${plant.intToMonth(minMonth)}';
    }
    return 'von ${plant.intToMonth(minMonth)} bis ${plant.intToMonth(maxMonth)}';
  }

  String _formatDepthRange(double minDepth, double maxDepth) {
    if (minDepth == maxDepth) {
      return '$minDepth cm';
    }
    return '$minDepth - $maxDepth cm';
  }

  String _formatTemperatureRange(int minTemp, int maxTemp) {
    if (minTemp == maxTemp) {
      return '$minTemp °C';
    }
    return '$minTemp - $maxTemp °C';
  }

  String _formatDurationRange(int minDays, int maxDays) {
    if (minDays == maxDays) {
      return '$minDays Tage';
    }
    return '$minDays - $maxDays Tage';
  }
}
