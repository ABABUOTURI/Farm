import 'package:farm_system_inventory/pages/dashboard/Drawer/Supervisor_Drawer/TaskSupervisor.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/Warehouse_Drawer/NotificationWarehouseStaff.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/inventory_management.dart';
import 'package:farm_system_inventory/pages/dashboard/Drawer/farmer_Drawer/reporting.dart';
import 'package:farm_system_inventory/pages/use_management/croplivestock_management.dart';
import 'package:farm_system_inventory/pages/use_management/suppliervendor_management.dart';
import 'package:farm_system_inventory/pages/use_management/user_manage_farmer.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    // Simulate fetching user data
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      //userName = "John Doe"; // Example name, replace with actual data fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide back button on DashboardPage
        title: Text('Welcome'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.9, // Control card height
          children: [
            _dashboardCard(
              context,
              Icons.list,
              'Inventory Management',
              InventoryManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.schedule,
              'Task Scheduling',
              SupervisorTaskSchedulingPage(),
            ),
            _dashboardCard(
              context,
              Icons.report,
              'Reporting',
              ReportingPage(),
            ),
            _dashboardCard(
              context,
              Icons.manage_accounts,
              'User Management',
              UserManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.agriculture,
              'Crop & Livestock Management',
              CropLivestockManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.shopping_cart,
              'Supplier & Vendor Management',
              SupplierVendorManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.notifications,
              'Notifications',
              WarehouseStaffNotificationCenterPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
      BuildContext context, IconData icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Reduced border radius
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32, // Reduced icon size
                color: Colors.green,
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


