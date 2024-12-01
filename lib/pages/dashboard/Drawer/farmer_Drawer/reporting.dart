import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:permission_handler/permission_handler.dart';  // Add this import

import '../../../../models/inventory_item.dart';
import '../../../../models/equipment.dart';
import '../../../../models/supplier_model.dart';
import '../../../../models/task.dart';

class ReportingPage extends StatefulWidget {
  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  Map<String, String> reportData = {};
  late Box<InventoryItem> inventoryBox;
  late Box<Equipment> equipmentBox;
  late Box<Supplier> supplierBox;
  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
    _openInventoryBox();
    _openEquipmentBox();
    _openSupplierBox();
    _openTaskBox();
  }

  // Fetch report data from Hive
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
        'Supplier Details': box.get('supplierDetails', defaultValue: 'No data available'),
        'Supplier Performance': box.get('supplierPerformance', defaultValue: 'No data available'),
        'Crop Health': box.get('cropHealth', defaultValue: 'No data available'),
        'Livestock Health': box.get('livestockHealth', defaultValue: 'No data available'),
      };
    });
  }

  // Open the inventory box
  Future<void> _openInventoryBox() async {
    inventoryBox = await Hive.openBox<InventoryItem>('inventoryBox');
    setState(() {});
  }

  // Open the equipment box
  Future<void> _openEquipmentBox() async {
    equipmentBox = await Hive.openBox<Equipment>('equipmentBox');
    setState(() {});
  }

  // Open the supplier box
  Future<void> _openSupplierBox() async {
    supplierBox = await Hive.openBox<Supplier>('supplierBox');
    setState(() {});
  }

  // Open the task box
  Future<void> _openTaskBox() async {
    taskBox = await Hive.openBox<Task>('taskBox');
    setState(() {});
  }

  // Build PDF document
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    
    // Add Inventory section
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: inventoryBox.values.map((item) => pw.Text('Item Name: ${item.name}\nQuantity: ${item.quantity}\n')).toList(),
        );
      },
    ));

    // Add Equipment section
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: equipmentBox.values.map((equipment) => pw.Text('Equipment Name: ${equipment.name}\n')).toList(),
        );
      },
    ));

    // Add Supplier section
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: supplierBox.values.map((supplier) => pw.Text('Supplier Name: ${supplier.name}\n')).toList(),
        );
      },
    ));

    // Add Task section
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: taskBox.values.map((task) => pw.Text('Task Title: ${task.title}\nAssigned To: ${task.assignedTo}\n')).toList(),
        );
      },
    ));

    // Save the PDF file to local storage
    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/report.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved to ${file.path}')));
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
              _buildSectionHeader('Inventory Reports'),
              ...inventoryBox.values.map((item) => _buildInventoryItemDetails(item)).toList(),
              SizedBox(height: 20),

              // Equipment Reports Section
              _buildSectionHeader('Equipment Reports'),
              ...equipmentBox.values.map((equipment) => _buildEquipmentDetails(equipment)).toList(),
              SizedBox(height: 20),

              // Supplier Reports Section
              _buildSectionHeader('Supplier Reports'),
              ...supplierBox.values.map((supplier) => _buildSupplierDetails(supplier)).toList(),
              SizedBox(height: 20),

              // Task Reports Section
              _buildSectionHeader('Task Reports'),
              ...taskBox.values.map((task) => _buildTaskDetails(task)).toList(),
              SizedBox(height: 20),

              // Export Reports Section
              Center(
  child: ElevatedButton(
    onPressed: () async {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        _generatePdf();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Storage permission required!')));
      }
    },
    child: Text('Export to PDF'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF08B797),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }

  // Build section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF08B797)),
    );
  }

  // Build inventory item details
  Widget _buildInventoryItemDetails(InventoryItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Name: ${item.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Quantity: ${item.quantity}', style: TextStyle(fontSize: 14)),
        Text('Unit: ${item.unit}', style: TextStyle(fontSize: 14)),
        Text('Item Type: ${item.type}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  // Build equipment details
  Widget _buildEquipmentDetails(Equipment equipment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Equipment Name: ${equipment.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Description: ${equipment.description}', style: TextStyle(fontSize: 14)),
        Text('Model: ${equipment.model}', style: TextStyle(fontSize: 14)),
        Text('Serial Number: ${equipment.serialNumber}', style: TextStyle(fontSize: 14)),
        Text('Last Maintenance: ${equipment.lastMaintenance.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 14)),
        Text('Availability: ${equipment.availability}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  // Build supplier details
  Widget _buildSupplierDetails(Supplier supplier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Supplier Name: ${supplier.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Contact: ${supplier.contact}', style: TextStyle(fontSize: 14)),
        Text('Email: ${supplier.email}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  // Build task details
  Widget _buildTaskDetails(Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Title: ${task.title}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Assigned To: ${task.assignedTo}', style: TextStyle(fontSize: 14)),
        Text('Due Date: ${task.dueDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 14)),
        Text('Description: ${task.description}', style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }
}
class Permission {
  // Simulating permission statuses
  static const String granted = 'granted';
  static const String denied = 'denied';
  static const String restricted = 'restricted';
  static const String unknown = 'unknown';

  // Simulated storage permission status (could be extended for other permissions)
  String _storagePermissionStatus = unknown;
  
  static var storage;

  // Getter for the storage permission status
  String get storageStatus => _storagePermissionStatus;

  // Method to simulate requesting storage permission
  Future<String> requestStoragePermission() async {
    // Simulating the permission request process (this could involve actual API calls)
    await Future.delayed(Duration(seconds: 1));  // Simulating a delay
    _storagePermissionStatus = granted;  // For simulation, assume permission is granted

    return _storagePermissionStatus;
  }

  // Method to check the current storage permission status
  Future<String> checkStoragePermissionStatus() async {
    // Simulating a check for current permission status
    await Future.delayed(Duration(seconds: 1));  // Simulating a delay
    return _storagePermissionStatus;
  }

  // Method to simulate handling the request and checking the status
  Future<void> handlePermissionRequest() async {
    final status = await requestStoragePermission();
    if (status == granted) {
      print('Permission granted. Proceeding with the task.');
    } else {
      print('Permission denied. Cannot proceed with the task.');
    }
  }
}

