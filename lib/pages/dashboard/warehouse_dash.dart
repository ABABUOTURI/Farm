// dashboard_page.dart
import 'package:flutter/material.dart';

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
  String userName = 'John Doe'; // Replace with dynamic user name

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
              _buildMetricCard('Current Inventory Levels', '75%', Icons.inventory),
              _buildMetricCard('Task Completion Rate', '85%', Icons.check_circle),
              _buildMetricCard('Upcoming Tasks', '5 tasks', Icons.event),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Low Stock Alert', 'Seeds inventory is below minimum level.', Icons.warning, Colors.orange),
              _buildAlertCard('Overdue Task', 'Equipment maintenance is overdue by 2 days.', Icons.error, Colors.red),
              _buildAlertCard('Upcoming Maintenance', 'Tractor maintenance scheduled in 3 days.', Icons.build, Colors.blue),
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
                  MaterialPageRoute(builder: (context) =>WarehouseStaffMyProfilePage()),
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

  // Method to open sidebar
  void _openSidebar(BuildContext context) {
    Scaffold.of(context).openDrawer();
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
