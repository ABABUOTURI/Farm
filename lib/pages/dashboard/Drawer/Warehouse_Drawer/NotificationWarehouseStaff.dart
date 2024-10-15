import 'package:flutter/material.dart';

class WarehouseStaffNotificationCenterPage extends StatefulWidget {
  @override
  _WarehouseStaffNotificationCenterPageState createState() => _WarehouseStaffNotificationCenterPageState();
}

class _WarehouseStaffNotificationCenterPageState extends State<WarehouseStaffNotificationCenterPage> {
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Sample function to fetch notifications (replace with actual data fetching)
  void _fetchNotifications() {
    notifications = [
      NotificationItem(
        title: 'Low Stock Alert',
        message: 'The fertilizer stock is below the minimum level.',
        type: NotificationType.lowStock,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      NotificationItem(
        title: 'Equipment Maintenance Due',
        message: 'The tractor requires maintenance soon.',
        type: NotificationType.maintenance,
        date: DateTime.now(),
      ),
      NotificationItem(
        title: 'Upcoming Task Reminder',
        message: 'Planting tasks scheduled for tomorrow.',
        type: NotificationType.taskReminder,
        date: DateTime.now().add(Duration(days: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notifications.isEmpty
            ? Center(child: Text('No notifications available.'))
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(notifications[index]);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
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
  lowStock,
  maintenance,
  taskReminder,
}
