import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SupervisorCropAndLivestockManagementPage extends StatefulWidget {
  @override
  _SupervisorCropAndLivestockManagementPageState createState() =>
      _SupervisorCropAndLivestockManagementPageState();
}

class _SupervisorCropAndLivestockManagementPageState
    extends State<SupervisorCropAndLivestockManagementPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Sample data for crops and livestock
  List<String> crops = ['Maize', 'Wheat', 'Rice'];
  List<String> livestock = ['Cattle', 'Goats', 'Poultry'];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop & Livestock Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Management Section
              Text(
                'Crop Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._buildEditableList('Crops', crops, _editCrop),
              _buildManagementCard(
                  'Track Crop Types',
                  'Monitor different crop types on the farm',
                  Icons.grass,
                  _trackCropTypes),
              _buildManagementCard(
                  'Planting Schedules',
                  'View upcoming planting schedules',
                  Icons.calendar_today,
                  _viewPlantingSchedules),
              _buildManagementCard(
                  'Harvesting Times',
                  'View harvesting times and schedules',
                  Icons.agriculture,
                  _viewHarvestingTimes),
              SizedBox(height: 20),

              // Livestock Management Section
              Text(
                'Livestock Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._buildEditableList('Livestock', livestock, _editLivestock),
              _buildManagementCard(
                  'Track Livestock Details',
                  'Monitor livestock breed, health status, and more',
                  Icons.pets,
                  _trackLivestockDetails),
              _buildManagementCard(
                  'Feeding Schedules',
                  'View feeding schedules for livestock',
                  Icons.food_bank,
                  _viewFeedingSchedules),
              _buildManagementCard(
                  'Health Checks',
                  'Receive notifications for livestock health checks',
                  Icons.health_and_safety,
                  _viewHealthChecks),
              SizedBox(height: 20),

              // Notifications Section
              Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard(
                  'Planting Reminder',
                  'Get reminders for planting schedules',
                  Icons.notifications_active,
                  () {
                _showNotification('Planting Reminder',
                    'Reminder: Upcoming planting is scheduled for tomorrow');
              }),
              _buildNotificationCard(
                  'Harvesting Reminder',
                  'Get reminders for harvesting schedules',
                  Icons.notifications,
                  () {
                _showNotification('Harvesting Reminder',
                    'Reminder: Harvesting is scheduled for next week');
              }),
              _buildNotificationCard(
                  'Health Check Alert',
                  'Get alerts for livestock health checks',
                  Icons.health_and_safety,
                  () {
                _showNotification('Health Check Alert',
                    'Alert: Health check needed for cattle #45');
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Builds an editable list of items (Crops or Livestock)
  List<Widget> _buildEditableList(
      String title, List<String> items, Function(String, int) onEdit) {
    return [
      Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      ...items.asMap().entries.map((entry) {
        int index = entry.key;
        String value = entry.value;
        return Card(
          elevation: 2,
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.edit, size: 40, color: Color(0xFF08B797)),
            title: Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                _showEditDialog(title, value, index, onEdit);
              },
            ),
          ),
        );
      }).toList(),
    ];
  }

  void _showEditDialog(
      String title, String value, int index, Function(String, int) onEdit) {
    TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onEdit(controller.text, index);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Edit functions for crops and livestock
  void _editCrop(String newCrop, int index) {
    setState(() {
      crops[index] = newCrop;
    });
  }

  void _editLivestock(String newLivestock, int index) {
    setState(() {
      livestock[index] = newLivestock;
    });
  }

  Widget _buildManagementCard(
      String title, String description, IconData icon, Function onPressed) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Color(0xFF08B797)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      String title, String description, IconData icon, Function onPressed) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Color(0xFF08B797)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }

  // Placeholder methods for handling management functions
  void _trackCropTypes() {
    print('Tracking Crop Types...');
  }

  void _viewPlantingSchedules() {
    print('Viewing Planting Schedules...');
  }

  void _viewHarvestingTimes() {
    print('Viewing Harvesting Times...');
  }

  void _trackLivestockDetails() {
    print('Tracking Livestock Details...');
  }

  void _viewFeedingSchedules() {
    print('Viewing Feeding Schedules...');
  }

  void _viewHealthChecks() {
    print('Viewing Health Checks...');
  }
}
