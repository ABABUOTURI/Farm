// reporting_page.dart
import 'package:flutter/material.dart';

class ReportingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporting'),
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

              // Inventory Reports Section
              Text(
                'Inventory Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard('Usage Report', 'View inventory usage details'),
              _buildReportCard('Low Stock Report', 'Items with low stock levels'),
              SizedBox(height: 20),

              // Equipment Reports Section
              Text(
                'Equipment Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard('Maintenance History', 'View maintenance history of equipment'),
              _buildReportCard('Equipment Usage', 'Track equipment usage details'),
              SizedBox(height: 20),

              // Task Completion Reports Section
              Text(
                'Task Completion Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard('Task Overview', 'Details on completed and pending tasks'),
              _buildReportCard('Task Performance', 'Analyze task completion rates'),
              SizedBox(height: 20),

              // Export Reports Section
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle export reports action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Export reports feature coming soon!')),
                    );
                  },
                  child: Text('Export to PDF / Excel'),
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

  // Method to build report card
  Widget _buildReportCard(String title, String description) {
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
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle viewing the detailed report
                  //ScaffoldMessenger.of(context).showSnackBar(
                   // SnackBar(content: Text('$title report coming soon!')),
                  //);
                },
                child: Text(
                  'View Details',
                  style: TextStyle(color: Color(0xFF08B797)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
