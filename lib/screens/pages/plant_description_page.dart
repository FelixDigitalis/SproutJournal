import 'package:flutter/material.dart';
import '../../plants/plant_model.dart';

class PlantDescriptionPage extends StatelessWidget {
  final Plant plant;

  const PlantDescriptionPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.germanName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.green[800],
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
                      'Ausaat von ${plant.intToMonth(plant.minSowBy)} bis ${plant.intToMonth(plant.maxSowBy)}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                      'Saattiefe: ${plant.sowingDepthMin} - ${plant.sowingDepthMax} cm',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                      'Keimtemperatur: ${plant.germinationTemperatureMin} - ${plant.germinationTemperatureMax} °C',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(
                      'Keimdauer: ${plant.germinationDurationMin} - ${plant.germinationDurationMax} Tage',
                      style: const TextStyle(fontSize: 16)),
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
                onPressed: () {
                  // TODO: on click add this plant to journal
                },
                elevation: 2.0,
                fillColor: Colors.green,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 35.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
