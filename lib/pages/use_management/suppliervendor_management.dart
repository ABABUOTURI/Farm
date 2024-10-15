// supplier_vendor_management_page.dart
import 'package:flutter/material.dart';

class SupplierVendorManagementPage extends StatefulWidget {
  @override
  _SupplierVendorManagementPageState createState() => _SupplierVendorManagementPageState();
}

class _SupplierVendorManagementPageState extends State<SupplierVendorManagementPage> {
  // Dummy data for demonstration purposes
  List<Map<String, dynamic>> suppliers = [
    {
      'name': 'ABC Supplies',
      'contact': 'John Doe - +1234567890',
      'products': 'Fertilizers, Seeds',
      'performance': 'On-Time Delivery: 90%, Quality: Good',
    },
    {
      'name': 'XYZ Equipment',
      'contact': 'Jane Smith - +9876543210',
      'products': 'Tractors, Irrigation Equipment',
      'performance': 'On-Time Delivery: 85%, Quality: Excellent',
    },
  ];

  // Method to add a new supplier
  void _addSupplier() {
    // Example to add a new supplier (In real scenario, use a form or dialog to get user input)
    setState(() {
      suppliers.add({
        'name': 'New Supplier',
        'contact': 'New Contact - +1122334455',
        'products': 'New Products',
        'performance': 'On-Time Delivery: 80%, Quality: Average',
      });
    });
  }

  // Method to delete a supplier
  void _deleteSupplier(int index) {
    setState(() {
      suppliers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier & Vendor Management'),
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

              // Supplier List Section
              Text(
                'Suppliers & Vendors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Displaying list of suppliers
              ...suppliers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> supplier = entry.value;
                return _buildSupplierCard(supplier, index);
              }).toList(),

              SizedBox(height: 20),

              // Add Supplier Button
              Center(
                child: ElevatedButton(
                  onPressed: _addSupplier,
                  child: Text('Add Supplier'),
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

  // Method to build supplier card
  Widget _buildSupplierCard(Map<String, dynamic> supplier, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplier['name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Contact: ${supplier['contact']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Products: ${supplier['products']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Performance: ${supplier['performance']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),

            // Delete Supplier Button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteSupplier(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
