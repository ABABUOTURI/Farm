// task_scheduling_page.dart
import 'package:flutter/material.dart';

class TaskSchedulingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduling'),
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

              // Task Assignment Section
              Text(
                'Task Assignment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTaskCard('Planting', 'Assign planting tasks to teams', 'High Priority'),
              _buildTaskCard('Harvesting', 'Schedule harvesting for next month', 'Medium Priority'),
              _buildTaskCard('Equipment Maintenance', 'Routine maintenance for tractors', 'Low Priority'),
              SizedBox(height: 20),

              // Calendar View Section
              Text(
                'Scheduled Tasks (Calendar View)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 200, // Placeholder for Calendar view
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    'Calendar View Coming Soon!',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Notification and Alerts Section
              Text(
                'Notifications & Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildNotificationCard('Upcoming Task', 'Planting scheduled for tomorrow'),
              _buildNotificationCard('Alert', 'High-priority harvesting due next week'),
              SizedBox(height: 20),

              // Add Task Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle add task action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Add task feature coming soon!')),
                    );
                  },
                  child: Text('Add New Task'),
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

  // Method to build task card
  Widget _buildTaskCard(String task, String description, String priority) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(description),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority: $priority',
                  style: TextStyle(color: Colors.orange),
                ),
                TextButton(
                  onPressed: () {
                    // Handle viewing task details
                    //ScaffoldMessenger.of(context).showSnackBar(
                     // SnackBar(content: Text('Viewing details for $task')),
                    //);
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Color(0xFF08B797)),
                  ),
                ),
              ],
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
