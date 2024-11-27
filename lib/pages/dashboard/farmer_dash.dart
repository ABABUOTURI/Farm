import 'package:farm_system_inventory/pages/dashboard/Drawer/Supervisor_Drawer/TaskSupervisor.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/FarmManager.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/inventory_management.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/my_profile.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/reporting.dart';
import 'package:farm_system_inventory/pages/use_management/croplivestock_management.dart';
import 'package:farm_system_inventory/pages/use_management/suppliervendor_management.dart';
import 'package:farm_system_inventory/pages/use_management/user_manage_farmer.dart';
import 'package:farm_system_inventory/utils/hive_data_manager.dart';
import 'package:farm_system_inventory/widgets/alert_card.dart';
import 'package:farm_system_inventory/widgets/loading_indicator.dart';
import 'package:farm_system_inventory/widgets/metrics_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;
  Map<String, String>? metricsData;
  Map<String, String>? alertsData;
  List<Map<String, dynamic>> upcomingTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      userName = await HiveDataManager.getUserName();
      metricsData = await HiveDataManager.getMetricsData();
      alertsData = await HiveDataManager.getAlertsData();
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleNewTask(Map<String, dynamic> task) {
    setState(() {
      upcomingTasks.add(task); // Add the new task to the upcoming tasks list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${userName ?? 'Guest'}!'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: isLoading
          ? LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key Metrics', style: _sectionHeaderStyle),
                    SizedBox(height: 10),
                    MetricsCard(
                      title: 'Current Inventory Levels',
                      value: metricsData?['inventory'] ?? 'No data available',
                      icon: Icons.inventory,
                    ),
                    MetricsCard(
                      title: 'Task Completion Rate',
                      value: metricsData?['taskCompletionRate'] ?? 'No data available',
                      icon: Icons.check_circle,
                    ),
                    MetricsCard(
                      title: 'Upcoming Tasks',
                      value: upcomingTasks.isEmpty
                          ? 'No upcoming tasks'
                          : '${upcomingTasks.length} tasks pending',
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(height: 20),
                    Text('Alerts', style: _sectionHeaderStyle),
                    SizedBox(height: 10),
                    AlertCard(
                      title: 'Low Stock Alert',
                      message: alertsData?['lowStock'] ?? 'No alerts',
                      icon: Icons.warning,
                      color: Colors.orange,
                    ),
                    AlertCard(
                      title: 'Overdue Tasks',
                      message: alertsData?['overdueTasks'] ?? 'No alerts',
                      icon: Icons.error,
                      color: Colors.red,
                    ),
                    AlertCard(
                      title: 'Maintenance Due',
                      message: alertsData?['maintenanceDue'] ?? 'No alerts',
                      icon: Icons.build,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
      drawer: FarmerDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the task scheduling page
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupervisorTaskSchedulingPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  TextStyle get _sectionHeaderStyle =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}

class FarmerDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text('Farm Manager Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _drawerListTile(context, Icons.person, 'My Profile', MyProfilePage()),
          _drawerListTile(context, Icons.list, 'Inventory Management', InventoryManagementPage()),
          _drawerListTile(context, Icons.schedule, 'Task Scheduling', SupervisorTaskSchedulingPage()),
          _drawerListTile(context, Icons.report, 'Reporting', ReportingPage()),
          _drawerListTile(context, Icons.manage_accounts, 'User Management', UserManagementPage()),
          _drawerListTile(context, Icons.agriculture, 'Crop & Livestock Management', CropLivestockManagementPage()),
          _drawerListTile(context, Icons.shopping_cart, 'Supplier & Vendor Management', SupplierVendorManagementPage()),
          _drawerListTile(context, Icons.store, 'Farm Manager', FarmManagerPage()),
        ],
      ),
    );
  }

  ListTile _drawerListTile(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Close the drawer
        Navigator.pop(context);
        
        // Navigate to the corresponding page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

class MetricsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MetricsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const AlertCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      margin: EdgeInsets.only(bottom: 10),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
