import 'package:farm_system_inventory/models/equipment.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditEquipmentPage extends StatefulWidget {
  final Equipment equipment;
  final int index;
  final Function(int, Equipment) onEditEquipment;

  EditEquipmentPage({
    required this.equipment,
    required this.index,
    required this.onEditEquipment,
  });

  @override
  _EditEquipmentPageState createState() => _EditEquipmentPageState();
}

class _EditEquipmentPageState extends State<EditEquipmentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _model, _serialNumber, _description;
  late DateTime _lastMaintenance;

  @override
  void initState() {
    super.initState();
    _name = widget.equipment.name;
    _model = widget.equipment.model;
    _serialNumber = widget.equipment.serialNumber;
    _description = widget.equipment.description;
    _lastMaintenance = widget.equipment.lastMaintenance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Equipment'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter equipment name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _model,
                decoration: InputDecoration(labelText: 'Model'),
                onSaved: (value) => _model = value!,
              ),
              TextFormField(
                initialValue: _serialNumber,
                decoration: InputDecoration(labelText: 'Serial Number'),
                onSaved: (value) => _serialNumber = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onEditEquipment(
                      widget.index,
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
                child: Text('Update Equipment'),
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
