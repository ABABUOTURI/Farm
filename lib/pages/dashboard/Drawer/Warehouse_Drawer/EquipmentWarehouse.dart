import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../models/equipment.dart'; // Assuming you have an Equipment model

class WarehouseStaffEquipmentManagementPage extends StatefulWidget {
  @override
  _WarehouseStaffEquipmentManagementPageState createState() =>
      _WarehouseStaffEquipmentManagementPageState();
}

class _WarehouseStaffEquipmentManagementPageState
    extends State<WarehouseStaffEquipmentManagementPage> {
  late Box<Equipment> equipmentBox;
  String _selectedType = 'All';

  // Controllers for form inputs
  final TextEditingController _equipmentNameController =
      TextEditingController();
  final TextEditingController _equipmentQuantityController =
      TextEditingController();
  final TextEditingController _equipmentUnitController =
      TextEditingController();
  String _equipmentType = 'Heavy';

  @override
  void initState() {
    super.initState();
    equipmentBox = Hive.box<Equipment>('equipmentBox');
  }

  @override
  void dispose() {
    _equipmentNameController.dispose();
    _equipmentQuantityController.dispose();
    _equipmentUnitController.dispose();
    super.dispose();
  }

  // Method to add new equipment to the warehouse
  void _addEquipment() {
    String equipmentName = _equipmentNameController.text.trim();
    String equipmentQuantity = _equipmentQuantityController.text.trim();
    String equipmentUnit = _equipmentUnitController.text.trim();

    int? quantity = int.tryParse(equipmentQuantity);

    // Only validate unit if the equipment type is 'Heavy'
    bool isHeavy = _equipmentType == 'Heavy';

    if (equipmentName.isNotEmpty &&
        quantity != null &&
        (isHeavy ? equipmentUnit.isNotEmpty : true)) {
      Equipment newEquipment = Equipment(
        name: equipmentName,
        quantity: quantity,
        unit: equipmentUnit,
        type: _equipmentType,
      );
      equipmentBox.add(newEquipment);
      _clearInputFields();
    } else {
      // Provide an appropriate error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please enter valid equipment details. Unit is required for heavy equipment.')),
      );
    }
  }

  // Method to clear input fields after adding an equipment
  void _clearInputFields() {
    _equipmentNameController.clear();
    _equipmentQuantityController.clear();
    _equipmentUnitController.clear();
    _equipmentType = 'Heavy';
  }

  // Method to restock an existing equipment using its Hive key
  void _restockEquipment(Equipment equipment, int additionalQuantity) {
    equipment.quantity += additionalQuantity;
    equipment.save(); // Update the equipment in Hive
    setState(() {}); // Refresh the UI
  }

  // Method to edit existing equipment
  void _editEquipment(int index, Equipment equipment) {
    equipmentBox.putAt(index, equipment); // Update the equipment in Hive
    setState(() {}); // Refresh the UI
    _showNotification('Equipment updated successfully!');
  }

  // Method to delete equipment
  void _deleteEquipment(int index) {
    equipmentBox.deleteAt(index);
    setState(() {});
    _showNotification('Equipment deleted successfully!');
  }

  // Filter and sort equipment items
  List<Equipment> _getFilteredItems() {
    List<Equipment> items = equipmentBox.values.toList();

    if (_selectedType == 'Low Stock') {
      items = items.where((item) => item.quantity <= 5).toList();
    } else if (_selectedType != 'All') {
      items = items.where((item) => item.type == _selectedType).toList();
    }

    items.sort((a, b) => b.key.compareTo(a.key));
    return items;
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
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for Equipment Items
              Text(
                'Equipment Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Scrollable Card for Equipment Items
              Container(
                height: 300,
                child: ValueListenableBuilder(
                  valueListenable: equipmentBox.listenable(),
                  builder: (context, Box<Equipment> box, _) {
                    List<Equipment> items = _getFilteredItems();

                    if (items.isEmpty) {
                      return Center(child: Text('No equipment available'));
                    }

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildEquipmentItemCard(item, index);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add New Equipment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildItemForm(),
            ],
          ),
        ),
      ),
      // Floating Action Buttons for Filtering Options
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedType = 'Heavy';
              });
            },
            backgroundColor:
                _selectedType == 'Heavy' ? Color(0xFF08B797) : Colors.grey[300],
            child: Icon(Icons.build),
            tooltip: 'Heavy Equipment',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedType = 'Light';
              });
            },
            backgroundColor:
                _selectedType == 'Light' ? Color(0xFF08B797) : Colors.grey[300],
            child: Icon(Icons.toys),
            tooltip: 'Light Equipment',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedType = 'All';
              });
            },
            backgroundColor:
                _selectedType == 'All' ? Color(0xFF08B797) : Colors.grey[300],
            child: Icon(Icons.select_all),
            tooltip: 'All',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedType = 'Low Stock';
              });
            },
            backgroundColor: _selectedType == 'Low Stock'
                ? Color(0xFF08B797)
                : Colors.grey[300],
            child: Icon(Icons.warning),
            tooltip: 'Low Stock',
          ),
        ],
      ),
    );
  }

  // Method to build equipment item card with restock option
  Widget _buildEquipmentItemCard(Equipment equipment, int index) {
    final TextEditingController _restockController = TextEditingController();

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
            '${equipment.name}, ${equipment.quantity}, ${equipment.unit}, ${equipment.type}'),
        subtitle: Text('Quantity: ${equipment.quantity}, ${equipment.unit}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _editEquipment(index, equipment);
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Restock ${equipment.name}'),
                      content: TextField(
                        controller: _restockController,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: 'Additional Quantity'),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(
                          child: Text('Restock'),
                          onPressed: () {
                            int additionalQuantity =
                                int.tryParse(_restockController.text) ?? 0;
                            if (additionalQuantity > 0) {
                              _restockEquipment(equipment, additionalQuantity);
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteEquipment(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Form to add a new equipment item
  Widget _buildItemForm() {
    return Column(
      children: [
        TextField(
          controller: _equipmentNameController,
          decoration: InputDecoration(
            labelText: 'Equipment Name',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _equipmentQuantityController,
          decoration: InputDecoration(
            labelText: 'Quantity',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        TextField(
          controller: _equipmentUnitController,
          decoration: InputDecoration(
            labelText: 'Unit (only for heavy equipment)',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: _equipmentType,
              onChanged: (String? newValue) {
                setState(() {
                  _equipmentType = newValue!;
                });
              },
              items: <String>['Heavy', 'Light']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _addEquipment,
              child: Text('Add Equipment'),
            ),
          ],
        ),
      ],
    );
  }
}
