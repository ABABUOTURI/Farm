import 'package:flutter/material.dart';

class SupervisorEquipmentManagementPage extends StatefulWidget {
  @override
  _SupervisorEquipmentManagementPageState createState() => _SupervisorEquipmentManagementPageState();
}

class _SupervisorEquipmentManagementPageState extends State<SupervisorEquipmentManagementPage> {
  List<Map<String, dynamic>> equipmentItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showAddEquipmentDialog(),
              child: Text('Add New Equipment'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: equipmentItems.length,
                itemBuilder: (context, index) {
                  return _buildEquipmentItemCard(equipmentItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentItemCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(item['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Model: ${item['model']}'),
            Text('Serial Number: ${item['serialNumber']}'),
            Text('Availability: ${item['availability']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditEquipmentDialog(item),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteEquipment(item),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEquipmentDialog() {
    _showEquipmentDialog();
  }

  void _showEditEquipmentDialog(Map<String, dynamic> item) {
    _showEquipmentDialog(item: item);
  }

  void _showEquipmentDialog({Map<String, dynamic>? item}) {
    final nameController = TextEditingController(text: item?['name']);
    final descriptionController = TextEditingController(text: item?['description']);
    final modelController = TextEditingController(text: item?['model']);
    final serialNumberController = TextEditingController(text: item?['serialNumber']);
    final availabilityController = TextEditingController(text: item?['availability'] ?? 'Available');
    final maintenanceDateController = TextEditingController(text: item?['nextMaintenanceDate'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add New Equipment' : 'Edit Equipment'),
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
                  decoration: InputDecoration(labelText: 'Next Maintenance Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (item == null) {
                  _addEquipment(
                    nameController.text,
                    descriptionController.text,
                    modelController.text,
                    serialNumberController.text,
                    availabilityController.text,
                    maintenanceDateController.text,
                  );
                } else {
                  _updateEquipment(
                    item,
                    nameController.text,
                    descriptionController.text,
                    modelController.text,
                    serialNumberController.text,
                    availabilityController.text,
                    maintenanceDateController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Update'),
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

  void _addEquipment(
      String name, String description, String model, String serialNumber, String availability, String nextMaintenanceDate) {
    setState(() {
      equipmentItems.add({
        'name': name,
        'description': description,
        'model': model,
        'serialNumber': serialNumber,
        'availability': availability,
        'nextMaintenanceDate': nextMaintenanceDate,
      });
    });
  }

  void _updateEquipment(Map<String, dynamic> item, String name, String description, String model, String serialNumber,
      String availability, String nextMaintenanceDate) {
    setState(() {
      item['name'] = name;
      item['description'] = description;
      item['model'] = model;
      item['serialNumber'] = serialNumber;
      item['availability'] = availability;
      item['nextMaintenanceDate'] = nextMaintenanceDate;
    });
  }

  void _deleteEquipment(Map<String, dynamic> item) {
    setState(() {
      equipmentItems.remove(item);
    });
  }
}
