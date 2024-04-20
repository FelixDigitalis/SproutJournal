import 'package:flutter/material.dart';

class PlantLibElement extends StatelessWidget {
  final String imagePath;
  final String title;

  const PlantLibElement({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: on click open plant description page or popup
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2), 
          borderRadius: BorderRadius.circular(8), 
        ),
        child: Column(
          children: <Widget>[
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.3, 
                child: Image.asset(imagePath),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
