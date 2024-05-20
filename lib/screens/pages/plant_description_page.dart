import 'package:flutter/material.dart';
import 'package:sprout_journal/screens/main_pages/main_pages_manager.dart';
import '../../models/plant_model.dart';
import '../../services/inventory_manager.dart';
// import '../../services/log.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/plants/${plant.englishName.toLowerCase()}.png',
                        fit: BoxFit.contain,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildDetailCard(
                            'Ausaat',
                            _formatSowingRange(plant.minSowBy, plant.maxSowBy),
                            context),
                        _buildDetailCard(
                            'Saattiefe',
                            _formatDepthRange(
                                plant.sowingDepthMin, plant.sowingDepthMax),
                            context),
                        _buildDetailCard(
                            'Keimtemperatur',
                            _formatTemperatureRange(
                                plant.germinationTemperatureMin,
                                plant.germinationTemperatureMax),
                            context),
                        _buildDetailCard(
                            'Keimdauer',
                            _formatDurationRange(plant.germinationDurationMin,
                                plant.germinationDurationMax),
                            context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddButton(context),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondary)),
        subtitle: Text(value,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      ),
    );
  }

  Align _buildAddButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () => _showAddPlantDialog(context),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  void _showAddPlantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pflanze hinzufügen",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          content: Text("Möchten Sie diese Pflanze zum Inventar hinzufügen?",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                InventoryManager.instance.addPlantToInventory(plant.id);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const PageManager(),
                  ),
                );
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
