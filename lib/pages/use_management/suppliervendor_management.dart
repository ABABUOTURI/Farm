import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_system_inventory/models/supplier_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SupplierVendorManagementPage extends StatefulWidget {
  @override
  _SupplierVendorManagementPageState createState() =>
      _SupplierVendorManagementPageState();
}

class _SupplierVendorManagementPageState
    extends State<SupplierVendorManagementPage> {
  late Box<Supplier> supplierBox;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    supplierBox = await Hive.openBox<Supplier>('supplierBox');
    setState(() {}); // Refresh the UI once box is ready
  }

  // Method to show the dialog for adding a new supplier
  void _showAddSupplierDialog() {
    String name = '';
    String contact = '';
    String products = '';
    String performance = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Contact'),
                  onChanged: (value) {
                    contact = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Products'),
                  onChanged: (value) {
                    products = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Performance'),
                  onChanged: (value) {
                    performance = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add Supplier'),
              onPressed: () {
                _addSupplier(name, contact, products, performance);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Method to add a new supplier to Firestore and Hive
  void _addSupplier(
      String name, String contact, String products, String performance) async {
    Supplier newSupplier = Supplier(
      name: name,
      contact: contact,
      products: products,
      performance: performance,
    );

    // Save to Hive
    await supplierBox.add(newSupplier);

    // Save to Firestore
    await firestore.collection('suppliers').add({
      'name': name,
      'contact': contact,
      'products': products,
      'performance': performance,
    });

    setState(() {}); // Refresh the UI
  }

  // Method to delete a supplier
  void _deleteSupplier(int index) async {
    await supplierBox.deleteAt(index);
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier & Vendor Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: supplierBox.isOpen
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Suppliers & Vendors',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: supplierBox.length,
                      itemBuilder: (context, index) {
                        Supplier supplier = supplierBox.getAt(index)!;
                        return _buildSupplierCard(supplier, index);
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _showAddSupplierDialog,
                        child: Text('Add Supplier'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF08B797),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator until box is ready
    );
  }

  Widget _buildSupplierCard(Supplier supplier, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplier.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Contact: ${supplier.contact}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Products: ${supplier.products}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Performance: ${supplier.performance}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
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
