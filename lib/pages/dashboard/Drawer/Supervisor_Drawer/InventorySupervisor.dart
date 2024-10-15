import 'package:flutter/material.dart';

class SupervisorInventoryManagementPage extends StatefulWidget {
  @override
  _SupervisorInventoryManagementPageState createState() => _SupervisorInventoryManagementPageState();
}

class _SupervisorInventoryManagementPageState extends State<SupervisorInventoryManagementPage> {
  List<Map<String, dynamic>> inventoryItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showAddItemDialog(),
              child: Text('Add New Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: inventoryItems.length,
                itemBuilder: (context, index) {
                  return _buildInventoryItemCard(inventoryItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItemCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(item['name']),
        subtitle: Text('Stock: ${item['stock']} (Min: ${item['minStock']})'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditItemDialog(item),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(item),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    _showItemDialog();
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    _showItemDialog(item: item);
  }

  void _showItemDialog({Map<String, dynamic>? item}) {
    final nameController = TextEditingController(text: item?['name']);
    final stockController = TextEditingController(text: item?['stock']?.toString());
    final minStockController = TextEditingController(text: item?['minStock']?.toString());
    final expirationDateController = TextEditingController(text: item?['expirationDate'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add New Item' : 'Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(labelText: 'Stock Level'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: minStockController,
                  decoration: InputDecoration(labelText: 'Minimum Stock Level'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: expirationDateController,
                  decoration: InputDecoration(labelText: 'Expiration Date (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (item == null) {
                  _addItem(
                    nameController.text,
                    int.parse(stockController.text),
                    int.parse(minStockController.text),
                    expirationDateController.text,
                  );
                } else {
                  _updateItem(item, nameController.text,
                      int.parse(stockController.text),
                      int.parse(minStockController.text),
                      expirationDateController.text);
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addItem(String name, int stock, int minStock, String expirationDate) {
    setState(() {
      inventoryItems.add({
        'name': name,
        'stock': stock,
        'minStock': minStock,
        'expirationDate': expirationDate,
      });
    });
  }

  void _updateItem(Map<String, dynamic> item, String name, int stock, int minStock, String expirationDate) {
    setState(() {
      item['name'] = name;
      item['stock'] = stock;
      item['minStock'] = minStock;
      item['expirationDate'] = expirationDate;
    });
  }

  void _deleteItem(Map<String, dynamic> item) {
    setState(() {
      inventoryItems.remove(item);
    });
  }
}
