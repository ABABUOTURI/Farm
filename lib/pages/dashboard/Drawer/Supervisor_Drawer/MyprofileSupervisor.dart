// my_profile_page.dart
import 'package:flutter/material.dart';

class SupervisorMyProfilePage extends StatelessWidget {
  // Dummy data for demonstration purposes
  final String userName = 'John Doe';
  final String email = 'johndoe@example.com';
  final String phoneNumber = '+1234567890';
  final String department = 'Farm Operations';
  final String responsibilities = 'Supervising farm activities, equipment management, inventory monitoring';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Profile'),
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

              // User Information Section
              Text(
                'Supervisor Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildProfileInfoCard('Name', userName, Icons.person),
              _buildProfileInfoCard('Email', email, Icons.email),
              _buildProfileInfoCard('Phone', phoneNumber, Icons.phone),
              _buildProfileInfoCard('Department', department, Icons.work),
              _buildProfileInfoCard('Responsibilities', responsibilities, Icons.assignment),
              SizedBox(height: 20),

              // Activity Logs Section
              Text(
                'Activity Logs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildActivityLogCard('Reviewed inventory status', '2 hours ago'),
              _buildActivityLogCard('Scheduled equipment maintenance', '1 day ago'),
              _buildActivityLogCard('Approved harvesting schedule', '3 days ago'),
              SizedBox(height: 20),

              // Manage Notifications Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle manage notifications action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Manage notifications feature coming soon!')),
                    );
                  },
                  child: Text('Manage Notifications'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Edit Profile Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle edit profile action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit profile feature coming soon!')),
                    );
                  },
                  child: Text('Edit Profile'),
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

  // Method to build profile info card
  Widget _buildProfileInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Color(0xFF08B797)),
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
                    value,
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

  // Method to build activity log card
  Widget _buildActivityLogCard(String activity, String timeAgo) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.history, size: 40, color: Color(0xFF08B797)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    timeAgo,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
