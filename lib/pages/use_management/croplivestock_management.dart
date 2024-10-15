// crop_livestock_management_page.dart
import 'package:flutter/material.dart';

class CropLivestockManagementPage extends StatefulWidget {
  @override
  _CropLivestockManagementPageState createState() =>
      _CropLivestockManagementPageState();
}

class _CropLivestockManagementPageState
    extends State<CropLivestockManagementPage> {
  // Dummy data for demonstration purposes
  List<Map<String, String>> cropRecords = [
    {'Crop': 'Wheat', 'Planting Date': '2024-10-01', 'Harvesting Date': '2025-02-15'},
    {'Crop': 'Maize', 'Planting Date': '2024-09-15', 'Harvesting Date': '2025-01-20'},
  ];

  List<Map<String, String>> livestockRecords = [
    {'Breed': 'Holstein', 'Health Status': 'Healthy', 'Feeding Time': '7:00 AM'},
    {'Breed': 'Angus', 'Health Status': 'Sick', 'Feeding Time': '6:30 AM'},
  ];

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
              SizedBox(height: 20), // Added space to accommodate AppBar height

              // Crop Management Section
              Text(
                'Crop Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildCropList(),
              SizedBox(height: 20),

              // Livestock Management Section
              Text(
                'Livestock Management',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildLivestockList(),
              SizedBox(height: 20),

              // Notifications Section
              Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard('Upcoming Harvest', 'Wheat harvest due on 2025-02-15', Icons.notifications_active, Colors.green),
              _buildNotificationCard('Health Alert', 'Angus cattle needs medical attention', Icons.warning, Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the crop list
  Widget _buildCropList() {
    return Column(
      children: cropRecords.map((crop) {
        return Card(
          elevation: 2,
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.grass, color: Color(0xFF08B797)),
            title: Text(crop['Crop']!),
            subtitle: Text('Planting Date: ${crop['Planting Date']}, Harvesting Date: ${crop['Harvesting Date']}'),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // Handle edit crop action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit crop feature coming soon!')),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // Method to build the livestock list
  Widget _buildLivestockList() {
    return Column(
      children: livestockRecords.map((livestock) {
        return Card(
          elevation: 2,
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.pets, color: Color(0xFF08B797)),
            title: Text(livestock['Breed']!),
            subtitle: Text('Health Status: ${livestock['Health Status']}, Feeding Time: ${livestock['Feeding Time']}'),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // Handle edit livestock action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit livestock feature coming soon!')),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  // Method to build notification card
  Widget _buildNotificationCard(String title, String message, IconData icon, Color color) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
