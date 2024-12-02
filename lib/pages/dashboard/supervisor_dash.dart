import 'package:farm_system_inventory/pages/dashboard/Drawer/Warehouse_Drawer/NotificationWarehouseStaff.dart';
import 'package:flutter/material.dart';
import '../use_management/suppliervendor_management.dart';
import 'Drawer/Supervisor_Drawer/CLManagement.dart';
import 'Drawer/Supervisor_Drawer/EquipmentSupervisor.dart';
import 'Drawer/Supervisor_Drawer/InventorySupervisor.dart';
import 'Drawer/Supervisor_Drawer/ReportSupervisor.dart';
import 'Drawer/Supervisor_Drawer/SupervisorNotification.dart';
import 'Drawer/Supervisor_Drawer/TaskSupervisor.dart';

class SupervisorDashboardPage extends StatefulWidget {
  @override
  _SupervisorDashboardPageState createState() =>
      _SupervisorDashboardPageState();
}

class _SupervisorDashboardPageState extends State<SupervisorDashboardPage> {
  String userName = ''; // Replace with dynamic user name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2, // Two columns for cards
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.9, // Control card height
          children: [
            _dashboardCard(
              context,
              Icons.inventory,
              'Inventory Management',
              SupervisorInventoryManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.agriculture,
              'Crop & Livestock Management',
              SupervisorCropAndLivestockManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.build,
              'Equipment Management',
              SupervisorEquipmentManagementPage(),
            ),
            _dashboardCard(
              context,
              Icons.report,
              'Reporting',
              ReportingPage(),
            ),
            _dashboardCard(
              context,
              Icons.notifications,
              'Notifications',
               WarehouseStaffNotificationCenterPage(),
            ),
            _dashboardCard(
              context,
              Icons.check_circle,
              'Task Management',
              SupervisorTaskSchedulingPage(),
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
                color: Color(0xFF08B797),
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
