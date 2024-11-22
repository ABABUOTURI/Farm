import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'Drawer/Warehouse_Drawer/EquipmentWarehouse.dart';
import 'Drawer/Warehouse_Drawer/InventoryWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/MyprofileWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/NotificationWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/SupplierVendorWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/TaskWarehouseStaff.dart';

class WarehouseStaffDashboardPage extends StatefulWidget {
  @override
  _WarehouseStaffDashboardPageState createState() => _WarehouseStaffDashboardPageState();
}

class _WarehouseStaffDashboardPageState extends State<WarehouseStaffDashboardPage> {
  String userName = ''; // Replace with dynamic user name from Hive
  String inventoryLevel = ''; // Replace with data from Hive
  String taskCompletionRate = ''; // Replace with data from Hive
  String upcomingTasks = ''; // Replace with data from Hive
  String lowStockAlert = ''; // Replace with data from Hive
  String overdueTaskAlert = ''; // Replace with data from Hive
  String maintenanceAlert = ''; // Replace with data from Hive

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data from Hive
  }

  // Fetch data from Hive
  void _loadData() async {
    var box = await Hive.openBox('warehouseData');

    setState(() {
      userName = box.get('userName', defaultValue: 'Warehouse Staff');
      inventoryLevel = box.get('inventoryLevel', defaultValue: 'No data available');
      taskCompletionRate = box.get('taskCompletionRate', defaultValue: 'No data available');
      upcomingTasks = box.get('upcomingTasks', defaultValue: 'No tasks available');
      lowStockAlert = box.get('lowStockAlert', defaultValue: 'No alerts available');
      overdueTaskAlert = box.get('overdueTaskAlert', defaultValue: 'No alerts available');
      maintenanceAlert = box.get('maintenanceAlert', defaultValue: 'No alerts available');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text('Welcome, $userName!'),
          ],
        ),
        backgroundColor: Color(0xFF08B797),
        actions: [],
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Key Metrics Section
              Text(
                'Key Metrics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMetricCard('Current Inventory Levels', inventoryLevel, Icons.inventory),
              _buildMetricCard('Task Completion Rate', taskCompletionRate, Icons.check_circle),
              _buildMetricCard('Upcoming Tasks', upcomingTasks, Icons.event),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Low Stock Alert', lowStockAlert, Icons.warning, Colors.orange),
              _buildAlertCard('Overdue Task', overdueTaskAlert, Icons.error, Colors.red),
              _buildAlertCard('Upcoming Maintenance', maintenanceAlert, Icons.build, Colors.blue),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Sidebar (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF08B797),
              ),
              child: Text(
                'Warehouse Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarehouseStaffMyProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Inventory Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Task Scheduling'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarehouseStaffTaskSchedulingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Equipment Maintenance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarehouseStaffEquipmentManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WarehouseStaffNotificationCenterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Method to build key metric card
  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Color(0xFF08B797)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build alert card
  Widget _buildAlertCard(String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
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
