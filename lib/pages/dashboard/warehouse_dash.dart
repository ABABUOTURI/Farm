import 'package:flutter/material.dart';
import 'Drawer/Warehouse_Drawer/EquipmentWarehouse.dart';
import 'Drawer/Warehouse_Drawer/InventoryWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/NotificationWarehouseStaff.dart';
import 'Drawer/Warehouse_Drawer/TaskWarehouseStaff.dart';

class WarehouseStaffDashboardPage extends StatefulWidget {
  @override
  _WarehouseStaffDashboardPageState createState() =>
      _WarehouseStaffDashboardPageState();
}

class _WarehouseStaffDashboardPageState
    extends State<WarehouseStaffDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide back button on DashboardPage
        title: Text('Warehouse Staff Dashboard'),
        backgroundColor: Color(0xFF08B797),
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
              Icons.inventory,
              'Inventory Management',
              InventoryManagementPage(),
            ),
            //_dashboardCard(
              //context,
              //Icons.check_circle,
              //'Task Scheduling',
              //WarehouseStaffTaskSchedulingPage(),
            //),
            _dashboardCard(
              context,
              Icons.build,
              'Equipment Maintenance',
              WarehouseStaffEquipmentManagementPage(),
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

  // Method to build dashboard card
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
