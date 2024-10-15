import 'package:flutter/material.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  // Sample data for inventory items
  List<Map<String, dynamic>> inventoryItems = [
    {'name': 'Item 1', 'quantity': 10},
    {'name': 'Item 2', 'quantity': 20},
    {'name': 'Item 3', 'quantity': 5},
  ];

  // Controller to handle new item name input
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemQuantityController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when not in use
    _itemNameController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  // Method to add a new item
  void _addItem() {
    String itemName = _itemNameController.text.trim();
    String itemQuantity = _itemQuantityController.text.trim();
    if (itemName.isNotEmpty && itemQuantity.isNotEmpty) {
      setState(() {
        inventoryItems.add({
          'name': itemName,
          'quantity': int.parse(itemQuantity),
        });
        _itemNameController.clear();
        _itemQuantityController.clear();
      });
    }
  }

  // Method to build inventory item card
  Widget _buildInventoryItemCard(String name, int quantity) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(name),
        subtitle: Text('Quantity: $quantity'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: inventoryItems.length,
                itemBuilder: (context, index) {
                  return _buildInventoryItemCard(
                    inventoryItems[index]['name'],
                    inventoryItems[index]['quantity'],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Add New Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _itemQuantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Item Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF08B797),
              ),
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
