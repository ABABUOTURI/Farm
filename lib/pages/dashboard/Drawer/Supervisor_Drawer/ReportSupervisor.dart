import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw; // For PDF generation
import 'package:excel/excel.dart'; // For Excel export

class SupervisorReportingPage extends StatefulWidget {
  @override
  _SupervisorReportingPageState createState() => _SupervisorReportingPageState();
}

class _SupervisorReportingPageState extends State<SupervisorReportingPage> {
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
              // Inventory Report Section
              Text(
                'Inventory Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Usage Report', 'Generate usage history report for inventory', Icons.inventory, _generateInventoryReport),
              _buildReportCard(
                  'Low Stock Report', 'Generate low stock alert report', Icons.warning, _generateLowStockReport),
              SizedBox(height: 20),

              // Equipment Report Section
              Text(
                'Equipment Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Maintenance History', 'View equipment maintenance history', Icons.build, _generateMaintenanceReport),
              _buildReportCard(
                  'Usage Report', 'Generate equipment usage report', Icons.settings, _generateEquipmentUsageReport),
              SizedBox(height: 20),

              // Task Completion Report Section
              Text(
                'Task Completion Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportCard(
                  'Completed Tasks', 'Generate report of completed tasks', Icons.check_circle, _generateTaskCompletionReport),
              _buildReportCard(
                  'Pending Tasks', 'Generate report of pending tasks', Icons.pending, _generatePendingTaskReport),
              SizedBox(height: 20),

              // Export Section
              Text(
                'Export Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildExportCard('Export to PDF', 'Export the current report to PDF format', Icons.picture_as_pdf, _exportToPDF),
              _buildExportCard('Export to Excel', 'Export the current report to Excel format', Icons.table_chart, _exportToExcel),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build report card
  Widget _buildReportCard(String title, String description, IconData icon, Function onPressed) {
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

  // Method to build export card
  Widget _buildExportCard(String title, String description, IconData icon, Function onPressed) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Color(0xFF08B797)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }

  // Placeholder methods for generating reports
  void _generateInventoryReport() {
    // Add logic for generating the inventory usage report
    print('Generating Inventory Usage Report...');
  }

  void _generateLowStockReport() {
    // Add logic for generating the low stock report
    print('Generating Low Stock Report...');
  }

  void _generateMaintenanceReport() {
    // Add logic for generating the equipment maintenance report
    print('Generating Maintenance History Report...');
  }

  void _generateEquipmentUsageReport() {
    // Add logic for generating the equipment usage report
    print('Generating Equipment Usage Report...');
  }

  void _generateTaskCompletionReport() {
    // Add logic for generating the completed tasks report
    print('Generating Completed Tasks Report...');
  }

  void _generatePendingTaskReport() {
    // Add logic for generating the pending tasks report
    print('Generating Pending Tasks Report...');
  }

  // Placeholder methods for exporting reports
  void _exportToPDF() {
    // Add logic to export the report to PDF
    print('Exporting report to PDF...');
  }

  void _exportToExcel() {
    // Add logic to export the report to Excel
    print('Exporting report to Excel...');
  }
}
