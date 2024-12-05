import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() =>
      _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemUnitController = TextEditingController();
  String _itemType = 'Consumable';
  String _selectedType = 'All';

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemQuantityController.dispose();
    _itemUnitController.dispose();
    super.dispose();
  }

  void _addItem() async {
    String itemName = _itemNameController.text.trim();
    String itemQuantity = _itemQuantityController.text.trim();
    String itemUnit = _itemUnitController.text.trim();
    int? quantity = int.tryParse(itemQuantity);

    if (itemName.isNotEmpty && quantity != null) {
      await _firestore.collection('inventory').add({
        'name': itemName,
        'quantity': quantity,
        'unit': itemUnit,
        'type': _itemType,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _clearInputFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item Added Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid item details.')),
      );
    }
  }

  void _clearInputFields() {
    _itemNameController.clear();
    _itemQuantityController.clear();
    _itemUnitController.clear();
    setState(() {
      _itemType = 'Consumable';
    });
  }

  Stream<List<Map<String, dynamic>>> _getFilteredItems() {
    Query query = _firestore.collection('inventory');
    if (_selectedType == 'Low Stock') {
      query = query.where('quantity', isLessThanOrEqualTo: 5);
    } else if (_selectedType != 'All') {
      query = query.where('type', isEqualTo: _selectedType);
    }
    return query.orderBy('timestamp', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
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
            children: [
              Text('Inventory Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getFilteredItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Text('No items available.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text('${item['name']}'),
                          subtitle: Text(
                              'Quantity: ${item['quantity']} ${item['unit']}, Type: ${item['type']}'),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Text('Add New Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(
                    labelText: 'Item Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _itemQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Quantity', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _itemUnitController,
                decoration: InputDecoration(
                    labelText: 'Unit', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _itemType,
                items: ['Consumable', 'Non-Consumable']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _itemType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addItem, child: Text('Add Item')),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() {
              _selectedType = 'Consumable';
            }),
            child: Icon(Icons.fastfood),
          ),
          FloatingActionButton(
            onPressed: () => setState(() {
              _selectedType = 'Non-Consumable';
            }),
            child: Icon(Icons.build),
          ),
          FloatingActionButton(
            onPressed: () => setState(() {
              _selectedType = 'All';
            }),
            child: Icon(Icons.select_all),
          ),
          FloatingActionButton(
            onPressed: () => setState(() {
              _selectedType = 'Low Stock';
            }),
            child: Icon(Icons.warning),
          ),
        ],
      ),
    );
  }
}
