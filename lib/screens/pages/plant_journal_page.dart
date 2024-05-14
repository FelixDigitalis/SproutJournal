import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/plant_model.dart';
import '../../services/inventory_manager.dart';
import '../../utils/log.dart';


class PlantJournalPage extends StatefulWidget {
  final Plant plant;
  final Map<String, dynamic> plantFromManager;

  const PlantJournalPage({
    super.key,
    required this.plant,
    required this.plantFromManager,
  });

  @override
  PlantJournalPageState createState() => PlantJournalPageState();
}

class PlantJournalPageState extends State<PlantJournalPage> {
  late TextEditingController _dateController;
  late TextEditingController _postController;
  late Map<String, dynamic> _plantData;
  bool _isUpdated = false;

  @override
  void initState() {
    try {
      super.initState();
    } catch (e) {
      Log().e(e.toString());
    } finally {
      _dateController = TextEditingController(
        text: widget.plantFromManager['plantingDate'],
      );
      _postController = TextEditingController();
      _plantData = widget.plantFromManager;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _postController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_plantData['plantingDate']) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      int state = await InventoryManager.instance
          .updatePlantingDate(widget.plantFromManager['plantID'], formattedDate);

      Log().e(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plant.germanName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/images/plants/${widget.plant.englishName.toLowerCase()}.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.plant.germanName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Gepflanzt am',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        readOnly: true,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                  // TODO: Add posts here
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      decoration: InputDecoration(
                        labelText: 'Neuer Journal Eintrag',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
