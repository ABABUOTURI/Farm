import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../use_management/croplivestock_management.dart';
import '../use_management/suppliervendor_management.dart';
import '../use_management/user_manage_farmer.dart';
import 'Drawer/farmer_Drawer/FarmManager.dart';
import 'Drawer/farmer_Drawer/inventory_management.dart';
import 'Drawer/farmer_Drawer/my_profile.dart';
import 'Drawer/farmer_Drawer/reporting.dart';
import 'Drawer/farmer_Drawer/task_scheduling.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  Map<String, String>? metricsData;
  Map<String, String>? alertsData;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchMetricsData();
    _fetchAlertsData();
  }

  void _fetchUserName() async {
    var box = await Hive.openBox('userBox');
    setState(() {
      userName = box.get('userName') ?? 'Guest';
    });
  }

  void _fetchMetricsData() async {
    // Fetch the data from Hive or any other source and update the metricsData map
    // Example data population, replace this with actual data fetching logic
    setState(() {
      metricsData = {
        'inventory': '100 Items',
        'taskCompletionRate': '85%',
        'upcomingTasks': '5 Tasks'
      };
    });
  }

  void _fetchAlertsData() async {
    // Fetch the data from Hive or any other source and update the alertsData map
    // Example data population, replace this with actual data fetching logic
    setState(() {
      alertsData = {
        'lowStock': 'Only 10 items left!',
        'overdueTasks': '2 tasks overdue!',
        'maintenanceDue': 'Equipment maintenance is due.'
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 8),
            Text('Welcome, ${userName ?? 'Guest'}!'),
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
              SizedBox(height: 20),

              // Key Metrics Section
              Text(
                'Key Metrics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMetricsCard(
                  'Current Inventory Levels', metricsData?['inventory'] ?? 'No data available', Icons.inventory),
              _buildMetricsCard(
                  'Task Completion Rate', metricsData?['taskCompletionRate'] ?? 'No data available', Icons.check_circle),
              _buildMetricsCard(
                  'Upcoming Tasks', metricsData?['upcomingTasks'] ?? 'No data available', Icons.calendar_today),
              SizedBox(height: 20),

              // Alerts Section
              Text(
                'Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAlertCard('Low Stock Alert', alertsData?['lowStock'] ?? 'No alerts', Icons.warning, Colors.orange),
              _buildAlertCard('Overdue Tasks', alertsData?['overdueTasks'] ?? 'No alerts', Icons.error, Colors.red),
              _buildAlertCard('Maintenance Due', alertsData?['maintenanceDue'] ?? 'No alerts', Icons.build, Colors.red),
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
            _drawerListTile(Icons.person, 'My Profile', MyProfilePage()),
            _drawerListTile(Icons.manage_accounts, 'User Management', UserManagementPage()),
            _drawerListTile(Icons.agriculture, 'Crop & Livestock Management', CropLivestockManagementPage()),
            _drawerListTile(Icons.shopping_cart, 'Supplier & Vendor Management', SupplierVendorManagementPage()),
            _drawerListTile(Icons.list, 'Inventory Management', InventoryManagementPage()),
            _drawerListTile(Icons.schedule, 'Task Scheduling', TaskSchedulingPage()),
            _drawerListTile(Icons.report, 'Reporting', ReportingPage()),
            //_drawerListTile(Icons.notifications, 'Notifications', NotificationCenterPage()),
            //_drawerListTile(Icons.settings, 'Settings', SettingsPage()),
            _drawerListTile(Icons.store, 'Farm Manager', FarmManagerPage()),
          ],
        ),
      ),
    );
  }

  ListTile _drawerListTile(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  void _openSidebar(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

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

  Widget _buildAlertCard(String title, String message, IconData icon, Color color) {
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
