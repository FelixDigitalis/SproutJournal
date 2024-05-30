import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprout_journal/models/plant_model.dart';
import 'package:sprout_journal/services/inventory_manager.dart';
import 'package:sprout_journal/utils/log.dart';

class JournalPlantHeader extends StatefulWidget {
  final Plant plant;
  final TextEditingController dateController;
  final String plantingDate;
  final int dbUUID;
  final Function(String) onDateChanged;

  const JournalPlantHeader({
    super.key,
    required this.plant,
    required this.dateController,
    required this.plantingDate,
    required this.dbUUID,
    required this.onDateChanged, 
  });

  @override
  JournalPlantHeaderState createState() => JournalPlantHeaderState();
}

class JournalPlantHeaderState extends State<JournalPlantHeader> {
  late String _currentPlantingDate;

  @override
  void initState() {
    super.initState();
    _currentPlantingDate = widget.plantingDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                controller: widget.dateController,
                decoration: InputDecoration(
                  labelText: 'Gepflanzt am',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _changeDate(context),
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
    );
  }

  // logic for the calendar element to change the date
  Future<void> _changeDate(BuildContext context) async {
    Log().d("Plant: ${widget.dbUUID}, Name: ${widget.plant.germanName}");
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd.MM.yyyy').parse(_currentPlantingDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    Log().d(picked.toString()); 
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      final displayDate = DateFormat('dd.MM.yyyy').format(picked);
      int state = await InventoryManager.instance.updatePlantingDate(widget.dbUUID, formattedDate);

      if (state == 1) {
        setState(() {
          _currentPlantingDate = displayDate;
          widget.dateController.text = displayDate;
        });
        widget.onDateChanged(displayDate); 
      }
    }
  }
}
