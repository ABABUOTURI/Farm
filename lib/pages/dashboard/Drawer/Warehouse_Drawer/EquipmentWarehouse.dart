import 'package:flutter/material.dart';

class WarehouseStaffEquipmentManagementPage extends StatefulWidget {
  @override
  _WarehouseStaffEquipmentManagementPageState createState() => _WarehouseStaffEquipmentManagementPageState();
}

class _WarehouseStaffEquipmentManagementPageState extends State<WarehouseStaffEquipmentManagementPage> {
  List<Equipment> equipmentList = [];

  void _addEquipment(Equipment equipment) {
    setState(() {
      equipmentList.add(equipment);
    });
  }

  void _editEquipment(int index, Equipment equipment) {
    setState(() {
      equipmentList[index] = equipment;
    });
  }

  void _deleteEquipment(int index) {
    setState(() {
      equipmentList.removeAt(index);
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farm Equipment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: equipmentList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildEquipmentCard(equipmentList[index], index);
                },
              ),
              SizedBox(height: 20),

              // Add Equipment Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEquipmentPage(
                          onAddEquipment: _addEquipment,
                        ),
                      ),
                    );
                  },
                  child: Text('Add Equipment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(Equipment equipment, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              equipment.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Model: ${equipment.model}'),
            Text('Serial Number: ${equipment.serialNumber}'),
            Text('Description: ${equipment.description}'),
            Text('Last Maintenance: ${equipment.lastMaintenance.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Equipment Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEquipmentPage(
                          equipment: equipment,
                          index: index,
                          onEditEquipment: _editEquipment,
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteEquipment(index);
                    _showNotification('Equipment deleted successfully!');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Equipment Model
class Equipment {
  String name;
  String description;
  String model;
  String serialNumber;
  DateTime lastMaintenance;

  Equipment({
    required this.name,
    required this.description,
    required this.model,
    required this.serialNumber,
    required this.lastMaintenance,
  });
}

// Placeholder for Add Equipment Page
class AddEquipmentPage extends StatelessWidget {
  final Function(Equipment) onAddEquipment;

  AddEquipmentPage({required this.onAddEquipment});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  DateTime lastMaintenance = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Equipment'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Equipment Name'),
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
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            Text('Last Maintenance: ${lastMaintenance.toLocal().toString().split(' ')[0]}'),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: lastMaintenance,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != lastMaintenance) {
                  lastMaintenance = picked;
                }
              },
              child: Text('Select Last Maintenance Date'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final equipment = Equipment(
                    name: nameController.text,
                    description: descriptionController.text,
                    model: modelController.text,
                    serialNumber: serialNumberController.text,
                    lastMaintenance: lastMaintenance,
                  );
                  onAddEquipment(equipment);
                  Navigator.pop(context);
                },
                child: Text('Add Equipment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B797),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Edit Equipment Page
class EditEquipmentPage extends StatelessWidget {
  final Equipment equipment;
  final int index;
  final Function(int, Equipment) onEditEquipment;

  EditEquipmentPage({required this.equipment, required this.index, required this.onEditEquipment});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = equipment.name;
    descriptionController.text = equipment.description;
    modelController.text = equipment.model;
    serialNumberController.text = equipment.serialNumber;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Equipment'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Equipment Name'),
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
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final updatedEquipment = Equipment(
                    name: nameController.text,
                    description: descriptionController.text,
                    model: modelController.text,
                    serialNumber: serialNumberController.text,
                    lastMaintenance: equipment.lastMaintenance, // Keeping the same last maintenance date
                  );
                  onEditEquipment(index, updatedEquipment);
                  Navigator.pop(context);
                },
                child: Text('Update Equipment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF08B797),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
