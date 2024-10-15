import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/supplier_model.dart';
import 'models/user.dart';
import 'pages/auth/loader.dart';
import 'pages/dashboard/farmer_dash.dart';
import 'pages/dashboard/supervisor_dash.dart';
import 'pages/dashboard/warehouse_dash.dart';

void main() async {
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  //Hive.registerAdapter(SupplierAdapter());
  
  // Open a Hive box
  await Hive.openBox<User>('usersBox');
  //await Hive.openBox<Supplier>('suppliers');


  runApp(const FarmInventoryApp());
}

class FarmInventoryApp extends StatelessWidget {
  const FarmInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Inventory System',
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Set the LoaderPage as the initial home page
      home: LoaderPage(),
      routes: {
        '/farmer-dashboard': (context) =>  DashboardPage(),
        '/supervisor-dashboard': (context) => SupervisorDashboardPage(),
        '/warehouse-dashboard': (context) => WarehouseStaffDashboardPage(),
      },
    );
  }
}

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Manage your farm inventory here',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

// Example Registration Function to Store User Data Using Hive
void _registerUser(BuildContext context, String firstName, String lastName, String email, String phoneNumber, String password, String role, String location, String farmName) async {
  var userBox = Hive.box('userBox');

  // Store user details in Hive
  userBox.put('firstName', firstName);
  userBox.put('lastName', lastName);
  userBox.put('email', email);
  userBox.put('phoneNumber', phoneNumber);
  userBox.put('password', password);
  userBox.put('role', role);
  userBox.put('location', location);
  userBox.put('farmName', farmName);

  // Show success message
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Registration Successful'),
        content: Text('Your account has been created.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

@override
void dispose() {
  Hive.close(); // Close all opened boxes
  //super.dispose();
}
