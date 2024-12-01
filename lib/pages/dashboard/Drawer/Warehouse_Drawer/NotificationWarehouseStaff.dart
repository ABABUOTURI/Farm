import 'package:farm_system_inventory/models/equipment.dart';
import 'package:farm_system_inventory/models/inventory_item.dart';
import 'package:farm_system_inventory/models/task.dart';
import 'package:farm_system_inventory/models/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WarehouseStaffNotificationCenterPage extends StatefulWidget {
  @override
  _WarehouseStaffNotificationCenterPageState createState() =>
      _WarehouseStaffNotificationCenterPageState();
}

class _WarehouseStaffNotificationCenterPageState
    extends State<WarehouseStaffNotificationCenterPage> {
  List<NotificationItem> notifications = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Fetch notifications from Hive models
  void _fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });

    notifications.clear();

    // Fetch Equipment notifications
    var equipmentBox = await Hive.openBox<Equipment>('equipmentBox');
    for (var equipment in equipmentBox.values) {
      notifications.add(NotificationItem(
        title: 'Equipment Added: ${equipment.name}',
        message: 'Model: ${equipment.model}, Serial Number: ${equipment.serialNumber}',
        type: NotificationType.equipment,
        date: equipment.lastMaintenance,
      ));
    }

    // Fetch Inventory notifications
    var inventoryBox = await Hive.openBox<InventoryItem>('inventoryBox');
    for (var inventoryItem in inventoryBox.values) {
      notifications.add(NotificationItem(
        title: 'Inventory Alert: ${inventoryItem.name}',
        message: 'Quantity: ${inventoryItem.quantity}, Category: ${inventoryItem.category}',
        type: NotificationType.inventory,
        date: DateTime.now(), // Assuming current date
      ));
    }

    // Fetch Task notifications
    var taskBox = await Hive.openBox<Task>('tasksBox');
    for (var task in taskBox.values) {
      notifications.add(NotificationItem(
        title: 'New Task: ${task.task}',
        message: 'Priority: ${task.priority}, Assigned to: ${task.assignedTo}',
        type: NotificationType.task,
        date: DateTime.now(),
      ));
    }

    // Fetch Supplier notifications
    var supplierBox = await Hive.openBox<Supplier>('suppliersBox');
    for (var supplier in supplierBox.values) {
      notifications.add(NotificationItem(
        title: 'Supplier Added: ${supplier.name}',
        message: 'Products: ${supplier.products}, Contact: ${supplier.contact}',
        type: NotificationType.supplier,
        date: DateTime.now(),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Column(
        children: [
          // Filter dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: [
                'All',
                'Equipment',
                'Inventory',
                'Task',
                'Supplier',
              ].map((filter) {
                return DropdownMenuItem(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Loading indicator
                : notifications.isEmpty
                    ? Center(child: Text('No notifications available.'))
                    : ListView.builder(
                        itemCount: filteredNotifications().length,
                        itemBuilder: (context, index) {
                          return _buildNotificationCard(
                              filteredNotifications()[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Filtered notifications based on the selected filter
  List<NotificationItem> filteredNotifications() {
    if (_selectedFilter == 'All') {
      return notifications;
    }
    return notifications
        .where((notification) =>
            notification.type.name.toLowerCase() ==
            _selectedFilter.toLowerCase())
        .toList();
  }

  // Notification card builder
  Widget _buildNotificationCard(NotificationItem notification) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(notification.message),
            SizedBox(height: 5),
            Text(
              '${notification.date.toLocal()}'.split(' ')[0], // Display date only
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Notification model
class NotificationItem {
  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
  });
}

// Notification types
enum NotificationType {
  equipment,
  inventory,
  task,
  supplier,
}

extension NotificationTypeExtension on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.equipment:
        return 'Equipment';
      case NotificationType.inventory:
        return 'Inventory';
      case NotificationType.task:
        return 'Task';
      case NotificationType.supplier:
        return 'Supplier';
      default:
        return '';
    }
  }
}
