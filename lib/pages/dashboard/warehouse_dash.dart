import 'package:flutter/material.dart';
import 'Drawer/Warehouse_Drawer/EquipmentWarehouse.dart';
import 'Drawer/Warehouse_Drawer/InventoryWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/NotificationWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/TaskWarehouseStaff.dart';

class WarehouseStaffDashboardPage extends StatefulWidget {
  @override
  _WarehouseStaffDashboardPageState createState() => _WarehouseStaffDashboardPageState();
}

class _WarehouseStaffDashboardPageState extends State<WarehouseStaffDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text('Warehouse Staff Dashboard'),
          ],
        ),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Educational Content Section
              Text(
                'Welcome to the Warehouse Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'This dashboard provides an overview of warehouse operations, including inventory management, task scheduling, equipment maintenance, and more. Use this section to monitor key metrics and stay up-to-date with important alerts.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Key Metrics Section
              Text(
                'Key Metrics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMetricCard('Current Inventory Levels', 'This section helps track the availability of items in the warehouse. Ensure that inventory is properly stocked to meet demand.', Icons.inventory),
              _buildMetricCard('Task Completion Rate', 'Track the progress of tasks assigned to the warehouse team. This metric helps monitor the efficiency of operations.', Icons.check_circle),
              _buildMetricCard('Upcoming Tasks', 'Stay ahead by tracking tasks that are scheduled in the future. This helps in planning and managing work effectively.', Icons.event),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Low Stock Alert', 'This alert notifies when inventory levels are running low. Keep an eye on stock levels to avoid running out of critical items.', Icons.warning, Colors.orange),
              _buildAlertCard('Overdue Task', 'This alert notifies when a task is past its deadline. Ensure timely completion of tasks to maintain operational flow.', Icons.error, Colors.red),
              _buildAlertCard('Upcoming Maintenance', 'Stay informed about upcoming equipment maintenance to prevent breakdowns and ensure smooth operations.', Icons.build, Colors.blue),
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
  Widget _buildMetricCard(String title, String description, IconData icon) {
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
