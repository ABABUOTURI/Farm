import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/inventory_item.dart';
import 'models/supplier_model.dart';
import 'models/user.dart';
import 'models/task.dart';
import 'models/notification.dart';
import 'pages/auth/loader.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters for each model
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(SupplierAdapter());
  Hive.registerAdapter(InventoryItemAdapter()); // Register InventoryItem adapter

  // Open necessary Hive boxes asynchronously
  await Future.wait([
    Hive.openBox<User>('usersBox'),
    Hive.openBox<Task>('tasksBox'),
    Hive.openBox<NotificationModel>('notificationsBox'),
    Hive.openBox<Supplier>('suppliers'),
    Hive.openBox<InventoryItem>('inventoryBox'), // Open inventoryBox
  ]);

  // Set up a global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // Additional logging or handling can be added here if needed
  };

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoaderPage(),  // LoaderPage as the initial screen
    );
  }
}
