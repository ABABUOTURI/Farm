import 'package:farm_system_inventory/models/cl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/task.dart';
import 'models/notification.dart';
import 'models/supplier_model.dart';
import 'models/inventory_item.dart';
import 'models/equipment.dart';
import 'pages/auth/loader.dart'; // Your loader page

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register all adapters
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(SupplierAdapter());
  Hive.registerAdapter(InventoryItemAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(CropAdapter()); // Register the Crop adapter
  Hive.registerAdapter(LivestockAdapter()); // Register the Livestock adapter

  // Open boxes asynchronously
  await Future.wait([
    Hive.openBox<User>('usersBox'),
    Hive.openBox<Task>('taskBox'),
    Hive.openBox<NotificationModel>('notificationsBox'),
    Hive.openBox<Supplier>('suppliersBox'),
    Hive.openBox<InventoryItem>('inventoryBox'),
    Hive.openBox<Equipment>('equipmentBox'),
    Hive.openBox<Crop>('cropBox'), // Open Crop Box
    Hive.openBox<Livestock>('livestockBox'), // Open Livestock Box
  ]);

  // Set up a global error handler for Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // Handle errors gracefully here (e.g., logging or custom error messages)
  };

  // Now run your app
  runApp(const FarmInventoryApp());
}

class FarmInventoryApp extends StatelessWidget {
  const FarmInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Inventory System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: LoaderPage(), // Display a loader page for authentication
    );
  }
}
