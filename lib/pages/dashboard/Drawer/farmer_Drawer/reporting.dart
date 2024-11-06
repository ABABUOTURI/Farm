import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ReportingPage extends StatefulWidget {
  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  Map<String, String> reportData = {}; // Store report data

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  // Method to fetch report data from Hive
  Future<void> _fetchReportData() async {
    var box = await Hive.openBox('reportBox');
    setState(() {
      reportData = {
        'Usage Report': box.get('usageReport', defaultValue: 'No data available'),
        'Low Stock Report': box.get('lowStockReport', defaultValue: 'No data available'),
        'Maintenance History': box.get('maintenanceHistory', defaultValue: 'No data available'),
        'Equipment Usage': box.get('equipmentUsage', defaultValue: 'No data available'),
        'Task Overview': box.get('taskOverview', defaultValue: 'No data available'),
        'Task Performance': box.get('taskPerformance', defaultValue: 'No data available'),
      };
    });
  }

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
              SizedBox(height: 20),

              // Inventory Reports Section
              Text(
                'Inventory Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Usage Report', reportData['Usage Report'] ?? 'No data available'),
              _buildReportCard(
                  'Low Stock Report', reportData['Low Stock Report'] ?? 'No data available'),
              SizedBox(height: 20),

              // Equipment Reports Section
              Text(
                'Equipment Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Maintenance History', reportData['Maintenance History'] ?? 'No data available'),
              _buildReportCard(
                  'Equipment Usage', reportData['Equipment Usage'] ?? 'No data available'),
              SizedBox(height: 20),

              // Task Completion Reports Section
              Text(
                'Task Completion Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Task Overview', reportData['Task Overview'] ?? 'No data available'),
              _buildReportCard(
                  'Task Performance', reportData['Task Performance'] ?? 'No data available'),
              SizedBox(height: 20),

              // Export Reports Section
              Center(
                child: ElevatedButton(
                  onPressed: () {
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

  // Method to build report card with scrollable content if necessary
  Widget _buildReportCard(String title, String content) {
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
            Container(
              height: 100, // Height to make the content scrollable if necessary
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title report coming soon!')),
                  );
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
