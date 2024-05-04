import 'package:flutter/material.dart';
import 'package:sprout_journal/models/plant_model.dart';
import '../pages/plant_description_page.dart';

class LibraryPlantElement extends StatelessWidget {
  final Plant plant;
  final String name;

  LibraryPlantElement({
    super.key,
    required this.plant,
  }) : name = plant.germanName;

  @override
  Widget build(BuildContext context) {
    // Construct the image path dynamically based on the plant's English name
    String imagePath =
        "assets/images/plants/${plant.englishName.toLowerCase()}.png";

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
        height: 200, 
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
