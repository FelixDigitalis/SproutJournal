import 'plant_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class PlantManager {
  Future<List<Plant>> loadPlants() async {
    final String response = await rootBundle.loadString('assets/plants.json');
    final data = json.decode(response);
    List<Plant> plants = (data as Map<String, dynamic>).entries.map((entry) {
      return Plant.fromJson({
        'GermanName': entry.value['GermanName'],
        ...entry.value
      });
    }).toList();
    return plants;
  }
}