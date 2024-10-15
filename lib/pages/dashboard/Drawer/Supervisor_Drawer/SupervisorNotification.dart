import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SupervisorNotificationCenterPage extends StatefulWidget {
  @override
  _SupervisorNotificationCenterPageState createState() => _SupervisorNotificationCenterPageState();
}

class _SupervisorNotificationCenterPageState extends State<SupervisorNotificationCenterPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _loadNotifications() {
    // Load notifications based on role (Supervisor) - Placeholder for actual data
    notifications = [
      'Low Inventory Alert: Seed stock below minimum levels.',
      'Equipment Maintenance Due: Tractor maintenance scheduled for tomorrow.',
      'Overdue Task: Harvesting task was due 3 days ago.',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alerts & Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(notifications[index]);
                },
              ),
            ),
            SizedBox(height: 20),
            _buildCustomSettingsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String notification) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(Icons.notification_important, size: 40, color: Colors.red),
        title: Text(notification, style: TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              notifications.remove(notification);
            });
          },
        ),
      ),
    );
  }

  Widget _buildCustomSettingsCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(Icons.settings, size: 40, color: Color(0xFF08B797)),
        title: Text('Notification Settings', style: TextStyle(fontSize: 16)),
        subtitle: Text('Customize alerts based on preferences'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // Navigate to settings or display a dialog to customize settings
            _customizeNotificationSettings();
          },
        ),
      ),
    );
  }

  void _customizeNotificationSettings() {
    // Placeholder for settings customization
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Settings'),
          content: Text('Customize notification settings here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
