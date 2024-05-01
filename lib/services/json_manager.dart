import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/plant_model.dart'; // Make sure to import your Plant model
import '../services/log.dart';

class JsonManager {

  List<Plant>? _cachedPlants;

  Future<List<Plant>> loadPlants() async {
    if (_cachedPlants != null) {
      return _cachedPlants!;
    }
    try {
      final String response = await rootBundle.loadString('assets/plants.json');
      final data = jsonDecode(response);
      if (data is Map<String, dynamic>) {
        _cachedPlants = data.entries.map((entry) {
          return Plant.fromJson({
            'id': entry.key, 
            ...entry.value
          });
        }).toList();
        return _cachedPlants!;
      } else {
        throw const FormatException('Expected a map of plants');
      }
    } catch (e) {
      Log().e('Error loading plants: $e');
      return [];
    }
  }

  Future<Plant?> getPlantById(int plantId) async {
    await loadPlants();
    return _cachedPlants?.firstWhere(
      (plant) => plant.id == plantId);
  }
}
