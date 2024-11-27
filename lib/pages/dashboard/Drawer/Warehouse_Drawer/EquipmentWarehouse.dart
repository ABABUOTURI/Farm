import 'package:farm_system_inventory/models/equipment.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/Warehouse_Drawer/AddEquipmentPage.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/Warehouse_Drawer/EditEquipmentPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class WarehouseStaffEquipmentManagementPage extends StatefulWidget {
  @override
  _WarehouseStaffEquipmentManagementPageState createState() =>
      _WarehouseStaffEquipmentManagementPageState();
}

class _WarehouseStaffEquipmentManagementPageState
    extends State<WarehouseStaffEquipmentManagementPage> {
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
        valueListenable: Hive.box<Equipment>('equipmentBox').listenable(),
        builder: (context, Box<Equipment> box, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farm Equipment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final equipment = box.getAt(index);
                      return _buildEquipmentCard(equipment!, index);
                    },
                  ),
                ),
                SizedBox(height: 20),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
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
            Text(
              'Last Maintenance: ${equipment.lastMaintenance.toLocal().toString().split(' ')[0]}',
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
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
