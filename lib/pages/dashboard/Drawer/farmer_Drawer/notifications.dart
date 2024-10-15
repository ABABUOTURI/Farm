// notification_center_page.dart
import 'package:flutter/material.dart';

class NotificationCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Center'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Added space to accommodate AppBar height

              // Notification Settings Section
              Text(
                'Notification Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationSettingCard('Low Stock Alert', 'Receive alerts when inventory is running low', true),
              _buildNotificationSettingCard('Equipment Maintenance', 'Get notified about upcoming equipment maintenance', true),
              _buildNotificationSettingCard('Overdue Tasks', 'Alerts for tasks that are overdue', false),
              SizedBox(height: 20),

              // Alerts and Notifications Section
              Text(
                'Alerts & Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard('Low Stock', 'Inventory for feed is below the required level'),
              _buildNotificationCard('Maintenance Due', 'Tractor maintenance scheduled for next week'),
              _buildNotificationCard('Overdue Task', 'Planting scheduled last week is not completed yet'),
              SizedBox(height: 20),

              // Customize Settings Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle customization of notification settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Customize notification settings feature coming soon!')),
                    );
                  },
                  child: Text('Customize Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build notification setting card
  Widget _buildNotificationSettingCard(String title, String description, bool isEnabled) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (bool value) {
                // Handle enabling/disabling notification
                // This is just a placeholder for now
              },
              activeColor: Color(0xFF08B797),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build notification card
  Widget _buildNotificationCard(String title, String message) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(message),
          ],
        ),
      ),
    );
  }
}
