import 'package:farm_system_inventory/models/equipment.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SupervisorEquipmentManagementPage extends StatefulWidget {
  @override
  _SupervisorEquipmentManagementPageState createState() =>
      _SupervisorEquipmentManagementPageState();
}

class _SupervisorEquipmentManagementPageState
    extends State<SupervisorEquipmentManagementPage> {
  late Box<Equipment> equipmentBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EquipmentAdapter());
    equipmentBox = await Hive.openBox<Equipment>('equipmentBox');
    setState(() {});
  }

  void _addEquipment(Equipment equipment) async {
    await equipmentBox.add(equipment);
    setState(() {});
    _showNotification('Equipment added successfully!');
  }

  void _editEquipment(int index, Equipment equipment) async {
    await equipmentBox.putAt(index, equipment);
    setState(() {});
    _showNotification('Equipment updated successfully!');
  }

  void _deleteEquipment(int index) async {
    await equipmentBox.deleteAt(index);
    setState(() {});
    _showNotification('Equipment deleted successfully!');
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: ValueListenableBuilder(
        valueListenable: equipmentBox.listenable(),
        builder: (context, Box<Equipment> box, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddEquipmentDialog();
                  },
                  child: Text('Add New Equipment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final equipment = box.getAt(index);
                      return _buildEquipmentCard(equipment!, index);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEquipmentCard(Equipment equipment, int index) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(equipment.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Model: ${equipment.model}'),
            Text('Serial Number: ${equipment.serialNumber}'),
            Text('Description: ${equipment.description}'),
            Text('Last Maintenance: ${equipment.lastMaintenance.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditEquipmentDialog(equipment, index),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteEquipment(index),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEquipmentDialog() {
    _showEquipmentDialog();
  }

  void _showEditEquipmentDialog(Equipment equipment, int index) {
    _showEquipmentDialog(equipment: equipment, index: index);
  }

  void _showEquipmentDialog({Equipment? equipment, int? index}) {
    final nameController = TextEditingController(text: equipment?.name);
    final descriptionController = TextEditingController(text: equipment?.description);
    final modelController = TextEditingController(text: equipment?.model);
    final serialNumberController = TextEditingController(text: equipment?.serialNumber);
    final availabilityController = TextEditingController(text: equipment?.availability ?? 'Available');
    final maintenanceDateController = TextEditingController(text: equipment?.lastMaintenance.toString().split(' ')[0]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(equipment == null ? 'Add New Equipment' : 'Edit Equipment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Equipment Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: 'Model'),
                ),
                TextField(
                  controller: serialNumberController,
                  decoration: InputDecoration(labelText: 'Serial Number'),
                ),
                TextField(
                  controller: availabilityController,
                  decoration: InputDecoration(labelText: 'Availability'),
                ),
                TextField(
                  controller: maintenanceDateController,
                  decoration: InputDecoration(labelText: 'Last Maintenance Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final equipment = Equipment(
                  name: nameController.text,
                  description: descriptionController.text,
                  model: modelController.text,
                  serialNumber: serialNumberController.text,
                  availability: availabilityController.text,
                  lastMaintenance: DateTime.parse(maintenanceDateController.text),
                );

                if (index == null) {
                  _addEquipment(equipment);
                } else {
                  _editEquipment(index, equipment);
                }
                Navigator.of(context).pop();
              },
              child: Text(equipment == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
