import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../use_management/croplivestock_management.dart';
import '../use_management/suppliervendor_management.dart';
import '../use_management/user_manage_farmer.dart';
import 'Drawer/farmer_Drawer/inventory_management.dart';
import 'Drawer/farmer_Drawer/my_profile.dart';
import 'Drawer/farmer_Drawer/notifications.dart';
import 'Drawer/farmer_Drawer/reporting.dart';
import 'Drawer/farmer_Drawer/settings.dart';
import 'Drawer/farmer_Drawer/task_scheduling.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName; // Initialize userName as nullable

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name from Hive
  }

  // Method to fetch the user's name from Hive
  void _fetchUserName() async {
    var box = await Hive.openBox('userBox'); // Open the Hive box where user data is stored
    setState(() {
      userName = box.get('userName'); // Fetch the username from the Hive database
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8), // Space between icon and text
            Text('Welcome, ${userName ?? 'Guest'}!'), // Show welcome message or "Guest" if null
          ],
        ),
        backgroundColor: Color(0xFF08B797),
        actions: [
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
                  'Current Inventory Levels', '100 Items', Icons.inventory),
              _buildMetricsCard(
                  'Task Completion Rate', '85%', Icons.check_circle),
              _buildMetricsCard(
                  'Upcoming Tasks', '5 Tasks', Icons.calendar_today),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Low Stock Alert', 'Only 10 items left!',
                  Icons.warning, Colors.orange),
              _buildAlertCard(
                  'Overdue Tasks', '2 tasks overdue!', Icons.error, Colors.red),
              _buildAlertCard('Maintenance Due',
                  'Equipment maintenance is due.', Icons.build, Colors.red),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF08B797),
              ),
              child: Text(
                'Farm Manager Menu',
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
                  MaterialPageRoute(builder: (context) => MyProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('User Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.agriculture),
              title: Text('Crop & Livestock Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CropLivestockManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Supplier & Vendor Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupplierVendorManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Inventory Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryManagementPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Task Scheduling'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskSchedulingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reporting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationCenterPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
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
