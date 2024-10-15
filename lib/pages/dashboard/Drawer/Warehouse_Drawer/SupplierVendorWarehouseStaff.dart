import 'package:flutter/material.dart';

class WarehouseStaffSupplierVendorManagementPage extends StatefulWidget {
  @override
  _WarehouseStaffSupplierVendorManagementPageState createState() => _WarehouseStaffSupplierVendorManagementPageState();
}

class _WarehouseStaffSupplierVendorManagementPageState extends State<WarehouseStaffSupplierVendorManagementPage> {
  List<Supplier> supplierList = [];

  void _addSupplier(Supplier supplier) {
    setState(() {
      supplierList.add(supplier);
    });
  }

  void _editSupplier(int index, Supplier supplier) {
    setState(() {
      supplierList[index] = supplier;
    });
  }

  void _deleteSupplier(int index) {
    setState(() {
      supplierList.removeAt(index);
    });
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier and Vendor Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suppliers and Vendors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: supplierList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildSupplierCard(supplierList[index], index);
                },
              ),
              SizedBox(height: 20),

              // Add Supplier Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSupplierPage(
                          onAddSupplier: _addSupplier,
                        ),
                      ),
                    );
                  },
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Contact: ${supplier.contactInfo}'),
            Text('Products Supplied: ${supplier.productsSupplied.join(", ")}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit Supplier Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSupplierPage(
                          supplier: supplier,
                          index: index,
                          onEditSupplier: _editSupplier,
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteSupplier(index);
                    _showNotification('Supplier deleted successfully!');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Supplier Model
class Supplier {
  String name;
  String contactInfo;
  List<String> productsSupplied;

  Supplier({
    required this.name,
    required this.contactInfo,
    required this.productsSupplied, required String performance, required String contact, required String products,
  });

  get contact => null;

  get products => null;

  get performance => null;
}

// Placeholder for Add Supplier Page
class AddSupplierPage extends StatelessWidget {
  final Function(Supplier) onAddSupplier;

  AddSupplierPage({required this.onAddSupplier});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController productsSuppliedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Supplier'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Supplier Name'),
            ),
            TextField(
              controller: contactInfoController,
              decoration: InputDecoration(labelText: 'Contact Information'),
            ),
            TextField(
              controller: productsSuppliedController,
              decoration: InputDecoration(labelText: 'Products Supplied (comma separated)'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final products = productsSuppliedController.text.split(',').map((e) => e.trim()).toList();
                  final supplier = Supplier(
                    name: nameController.text,
                    contactInfo: contactInfoController.text,
                    productsSupplied: products, performance: '', contact: '', products: '',
                  );
                  onAddSupplier(supplier);
                  Navigator.pop(context);
                },
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
    );
  }
}

// Placeholder for Edit Supplier Page
class EditSupplierPage extends StatelessWidget {
  final Supplier supplier;
  final int index;
  final Function(int, Supplier) onEditSupplier;

  EditSupplierPage({required this.supplier, required this.index, required this.onEditSupplier});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController productsSuppliedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = supplier.name;
    contactInfoController.text = supplier.contactInfo;
    productsSuppliedController.text = supplier.productsSupplied.join(", ");

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Supplier'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Supplier Name'),
            ),
            TextField(
              controller: contactInfoController,
              decoration: InputDecoration(labelText: 'Contact Information'),
            ),
            TextField(
              controller: productsSuppliedController,
              decoration: InputDecoration(labelText: 'Products Supplied (comma separated)'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final products = productsSuppliedController.text.split(',').map((e) => e.trim()).toList();
                  final updatedSupplier = Supplier(
                    name: nameController.text,
                    contactInfo: contactInfoController.text,
                    productsSupplied: products, performance: '', contact: '', products: '',
                  );
                  onEditSupplier(index, updatedSupplier);
                  Navigator.pop(context);
                },
                child: Text('Update Supplier'),
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
    );
  }
}
