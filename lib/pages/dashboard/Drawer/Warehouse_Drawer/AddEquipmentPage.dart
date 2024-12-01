import 'package:farm_system_inventory/models/equipment.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddEquipmentPage extends StatefulWidget {
  final Function(Equipment) onAddEquipment;

  AddEquipmentPage({required this.onAddEquipment});

  @override
  _AddEquipmentPageState createState() => _AddEquipmentPageState();
}

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _model, _serialNumber, _description;
  late DateTime _lastMaintenance;

  @override
  void initState() {
    super.initState();
    _lastMaintenance = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Equipment'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter equipment name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                onSaved: (value) => _model = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Serial Number'),
                onSaved: (value) => _serialNumber = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onAddEquipment(
                      Equipment(
                        name: _name,
                        model: _model,
                        serialNumber: _serialNumber,
                        description: _description,
                        lastMaintenance: _lastMaintenance, availability: '',
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Equipment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B797),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
