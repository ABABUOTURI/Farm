import 'package:flutter/material.dart';

class WarehouseStaffInventoryManagementPage extends StatefulWidget {
  @override
  _WarehouseStaffInventoryManagementPageState createState() => _WarehouseStaffInventoryManagementPageState();
}

class _WarehouseStaffInventoryManagementPageState extends State<WarehouseStaffInventoryManagementPage> {
  List<InventoryItem> inventoryItems = [];
  
  void _addInventoryItem(InventoryItem item) {
    setState(() {
      inventoryItems.add(item);
    });
  }

  void _editInventoryItem(int index, InventoryItem item) {
    setState(() {
      inventoryItems[index] = item;
    });
  }

  void _deleteInventoryItem(int index) {
    setState(() {
      inventoryItems.removeAt(index);
    });
  }

  void _showLowStockAlert() {
    // Logic to check low stock and show alert
    for (var item in inventoryItems) {
      if (item.quantity < item.minStockLevel) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name} is low on stock!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                itemCount: inventoryItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildInventoryItemCard(inventoryItems[index], index);
                },
              ),
              SizedBox(height: 20),

              // Add Inventory Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Add Inventory Item Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddInventoryItemPage(
                          onAddItem: _addInventoryItem,
                        ),
                      ),
                    );
                  },
                  child: Text('Add Inventory Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Check for low stock
              Center(
                child: ElevatedButton(
                  onPressed: _showLowStockAlert,
                  child: Text('Check Low Stock'),
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

  Widget _buildInventoryItemCard(InventoryItem item, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Quantity: ${item.quantity}'),
                  Text('Min Stock Level: ${item.minStockLevel}'),
                  Text('Expiration Date: ${item.expirationDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to Edit Inventory Item Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditInventoryItemPage(
                      item: item,
                      index: index,
                      onEditItem: _editInventoryItem,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteInventoryItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryItem {
  String name;
  int quantity;
  int minStockLevel;
  DateTime? expirationDate;

  InventoryItem({required this.name, required this.quantity, required this.minStockLevel, this.expirationDate});
}

// Placeholder for Add Inventory Item Page
class AddInventoryItemPage extends StatelessWidget {
  final Function(InventoryItem) onAddItem;

  AddInventoryItemPage({required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    // Implement form to add inventory item
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Inventory Item'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Center(
        child: Text('Form to add inventory item goes here.'),
      ),
    );
  }
}

// Placeholder for Edit Inventory Item Page
class EditInventoryItemPage extends StatelessWidget {
  final InventoryItem item;
  final int index;
  final Function(int, InventoryItem) onEditItem;

  EditInventoryItemPage({required this.item, required this.index, required this.onEditItem});

  @override
  Widget build(BuildContext context) {
    // Implement form to edit inventory item
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Inventory Item'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Center(
        child: Text('Form to edit inventory item goes here.'),
      ),
    );
  }
}
