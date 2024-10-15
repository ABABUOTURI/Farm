import 'package:flutter/material.dart';


import '../use_management/suppliervendor_management.dart';
import 'Drawer/Supervisor_Drawer/CLManagement.dart';
import 'Drawer/Supervisor_Drawer/EquipmentSupervisor.dart';
import 'Drawer/Supervisor_Drawer/InventorySupervisor.dart';
import 'Drawer/Supervisor_Drawer/MyprofileSupervisor.dart';
import 'Drawer/Supervisor_Drawer/ReportSupervisor.dart';
import 'Drawer/Supervisor_Drawer/SupervisorNotification.dart';
import 'Drawer/Supervisor_Drawer/TaskSupervisor.dart';



class SupervisorDashboardPage extends StatefulWidget {
  @override
  _SupervisorDashboardPageState createState() => _SupervisorDashboardPageState();
}

class _SupervisorDashboardPageState extends State<SupervisorDashboardPage> {
  // Dummy data for demonstration purposes
  String userName = 'Jane Smith'; // Replace with dynamic user name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8), // Space between icon and text
            Text('Welcome, $userName!'), // Welcome message in the AppBar
          ],
        ),
        backgroundColor: Color(0xFF08B797),
        actions: [
          // Menu icon to open sidebar
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _openSidebar(context),
          ),
        ],
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Added space to accommodate AppBar height

              // Key Metrics Section
              Text(
                'Key Metrics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMetricsCard(
                  'Current Inventory Levels', '200 Items', Icons.inventory),
              _buildMetricsCard(
                  'Task Completion Rate', '90%', Icons.check_circle),
              _buildMetricsCard(
                  'Pending Tasks', '3 Tasks', Icons.calendar_today),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Stock Alert', 'Only 5 items left!',
                  Icons.warning, Colors.orange),
              _buildAlertCard(
                  'Overdue Tasks', '1 task overdue!', Icons.error, Colors.red),
              _buildAlertCard('Maintenance Reminder',
                  'Equipment maintenance is due soon.', Icons.build, Colors.red),
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
                'Supervisor Menu',
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
                  MaterialPageRoute(builder: (context) => SupervisorMyProfilePage()),
                );
              },
            ),
           
            ListTile(
              leading: Icon(Icons.agriculture),
              title: Text('Crop & Livestock Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorCropAndLivestockManagementPage()),
                );
              },
            ),
            
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Inventory Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorInventoryManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: Text('Equipment Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorEquipmentManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Task Scheduling'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorTaskSchedulingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reporting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorReportingPage ()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorNotificationCenterPage()),
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

  // Method to build metrics card
  Widget _buildMetricsCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 40, color: Color(0xFF08B797)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(value, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build alert card
  Widget _buildAlertCard(
      String title, String message, IconData icon, Color color) {
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
                  Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(message, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
