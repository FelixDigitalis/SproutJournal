import '../models/plant_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../services/log.dart';

class PlantManager {

  Future<List<Plant>> loadPlants() async {
    try {
      final String response = await rootBundle.loadString('assets/plants.json');
      final data = jsonDecode(response);

      if (data is Map<String, dynamic>) {
        List<Plant> plants = data.entries.map((entry) {
          return Plant.fromJson({
            'GermanName': entry.value['GermanName'],
            ...entry.value
          });
        }).toList();
        return plants;
      } else {
        throw const FormatException('Unexpected JSON format');
      }
    } catch (e) {
      Log().e('Error loading plants: $e');
      return [];
    }
  }
}