import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/plant_model.dart';
import '../../services/inventory_manager.dart';

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
    super.initState();
    _dateController = TextEditingController(
      text: widget.plantFromManager['plantingDate'],
    );
    _postController = TextEditingController();
    _plantData = widget.plantFromManager;
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

      await InventoryManager.instance
          .updatePlantingDate(widget.plant.id, formattedDate);

      await _reloadState();
      setState(() {
        _isUpdated = true;
      });
    }
  }

  Future<void> _reloadState() async {
    final updatedPlantData = await InventoryManager.instance.getAllPlants();
    final newData =
        updatedPlantData.firstWhere((plant) => plant['id'] == widget.plant.id);

    setState(() {
      _plantData = newData;
      _dateController.text = _plantData['plantingDate'];
    });
  }

  Future<void> _addPost() async {
    final postContent = _postController.text.trim();
    if (postContent.isNotEmpty) {
      //TODO: Add post to the database

      _postController.clear();
      setState(() {
        _isUpdated = true;
      });
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadState,
          ),
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
                        onTap: () => _selectDate(context),
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
                  //TODO: Add posts here
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
                    onPressed: _addPost,
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
