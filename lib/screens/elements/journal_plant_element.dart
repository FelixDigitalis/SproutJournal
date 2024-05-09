import 'package:flutter/material.dart';
import 'package:sprout_journal/models/plant_model.dart';
import '../pages/plant_description_page.dart';

class JournalPlantElement extends StatelessWidget {
  final Plant plant;
  final String plantDate;

  const JournalPlantElement({
    super.key,
    required this.plant,
    required this.plantDate,
  });

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.germanName,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'gepflanzt am: $plantDate',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
