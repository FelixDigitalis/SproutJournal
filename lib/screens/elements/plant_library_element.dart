import 'package:flutter/material.dart';
import 'package:sprout_journal/plants/plant_model.dart';
import '../pages/plant_description_page.dart';


class PlantLibElement extends StatelessWidget {
  final String standardPlantImage = "./assets/images/standard_plant.png";
  final Plant plant;
  final String name;

  PlantLibElement({
    super.key,
    required this.plant,
  }) : name = plant.germanName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDescriptionPage(plant: plant),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8), 
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 1,
                    child: Image.asset(standardPlantImage),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary),
                ),
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              child: InkWell(
                // TODO: onTap: add to journal
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
