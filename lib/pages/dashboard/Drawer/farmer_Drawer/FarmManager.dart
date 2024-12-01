import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../models/user.dart';
import '../../../../models/inventory_item.dart';
import '../../../../models/supplier_model.dart';
import '../../../../models/task.dart';
import '../../../../models/notification.dart';

class FarmManagerPage extends StatefulWidget {
  @override
  _FarmManagerPageState createState() => _FarmManagerPageState();
}

class _FarmManagerPageState extends State<FarmManagerPage> {
  Future<void>? _initializeHiveBoxesFuture;
  late List<User> users = [];
  late List<InventoryItem> inventoryItems = [];
  late List<Supplier> suppliers = [];
  late List<Task> tasks = [];
  late List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _initializeHiveBoxesFuture = _initializeHiveBoxes();
  }

  Future<void> _initializeHiveBoxes() async {
    try {
      await Hive.openBox<User>('userBox');
      await Hive.openBox<InventoryItem>('inventoryBox');
      await Hive.openBox<Supplier>('supplierBox');
      await Hive.openBox<Task>('tasksBox');
      await Hive.openBox<NotificationModel>('notificationBox');

      setState(() {
        users = Hive.box<User>('userBox').values.toList();
        inventoryItems = Hive.box<InventoryItem>('inventoryBox').values.toList();
        suppliers = Hive.box<Supplier>('supplierBox').values.toList();
        tasks = Hive.box<Task>('taskBox').values.toList();
        notifications = Hive.box<NotificationModel>('notificationBox').values.toList();
      });
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  // Build individual card widgets as before
  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: ${user.email}'),
            Text('Phone: ${user.phoneNumber}'),
            Text('Role: ${user.role}'),
            Text('Farm: ${user.farmName}'),
            Text('Location: ${user.location}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItemCard(InventoryItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Quantity: ${item.quantity} ${item.unit}'),
            Text('Type: ${item.type}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplier.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Contact: ${supplier.contact}'),
            Text('Products: ${supplier.products}'),
            Text('Performance: ${supplier.performance}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.task,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Priority: ${task.priority}'),
           Text('Assigned To: ${task.assignedTo}'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Message: ${notification.message}'),
            Text('Date: ${notification.date.toLocal().toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(children: children),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Manager'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: FutureBuilder<void>(
        future: _initializeHiveBoxesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error initializing Hive: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: 'Users',
                      children: users.map(_buildUserCard).toList(),
                    ),
                    _buildSection(
                      title: 'Inventory Items',
                      children: inventoryItems.map(_buildInventoryItemCard).toList(),
                    ),
                    _buildSection(
                      title: 'Suppliers',
                      children: suppliers.map(_buildSupplierCard).toList(),
                    ),
                    _buildSection(
                      title: 'Tasks',
                      children: tasks.map(_buildTaskCard).toList(),
                    ),
                    _buildSection(
                      title: 'Notifications',
                      children: notifications.map(_buildNotificationCard).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
