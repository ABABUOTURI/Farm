import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../models/inventory_item.dart';

class InventoryManagementPage extends StatefulWidget {
  @override
  _InventoryManagementPageState createState() => _InventoryManagementPageState();
}

class _InventoryManagementPageState extends State<InventoryManagementPage> {
  late Box<InventoryItem> inventoryBox;
  String _selectedType = 'All';

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemUnitController = TextEditingController();
  String _itemType = 'Consumable';

  @override
  void initState() {
    super.initState();
    inventoryBox = Hive.box<InventoryItem>('inventoryBox');
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemQuantityController.dispose();
    _itemUnitController.dispose();
    super.dispose();
  }

  // Add new item
  void _addItem() {
    String itemName = _itemNameController.text.trim();
    String itemQuantity = _itemQuantityController.text.trim();
    String itemUnit = _itemUnitController.text.trim();
    int? quantity = int.tryParse(itemQuantity);

    bool isConsumable = _itemType == 'Consumable';

    if (itemName.isNotEmpty && quantity != null && (isConsumable ? itemUnit.isNotEmpty : true)) {
      InventoryItem newItem = InventoryItem(
        name: itemName,
        quantity: quantity,
        unit: itemUnit,
        type: _itemType,
      );
      inventoryBox.add(newItem);
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

  // Clear input fields
  void _clearInputFields() {
    _itemNameController.clear();
    _itemQuantityController.clear();
    _itemUnitController.clear();
    _itemType = 'Consumable';
  }

  // Filter and sort items
  List<InventoryItem> _getFilteredItems() {
    List<InventoryItem> items = inventoryBox.values.toList();

    if (_selectedType == 'Low Stock') {
      items = items.where((item) => item.quantity <= 5).toList();
    } else if (_selectedType != 'All') {
      items = items.where((item) => item.type == _selectedType).toList();
    }

    items.sort((a, b) => b.key.compareTo(a.key));
    return items;
  }

  // Restock item
  void _restockItem(InventoryItem item, int additionalQuantity) {
    item.quantity += additionalQuantity;
    item.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Inventory Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: ValueListenableBuilder(
                  valueListenable: inventoryBox.listenable(),
                  builder: (context, Box<InventoryItem> box, _) {
                    List<InventoryItem> items = _getFilteredItems();

                    if (items.isEmpty) {
                      return Center(child: Text('No items available'));
                    }

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildInventoryItemCard(item);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Add New Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildItemForm(),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(onPressed: () => setState(() { _selectedType = 'Consumable'; }), backgroundColor: _selectedType == 'Consumable' ? Color(0xFF08B797) : Colors.grey[300], child: Icon(Icons.fastfood), tooltip: 'Consumable'),
          SizedBox(height: 10),
          FloatingActionButton(onPressed: () => setState(() { _selectedType = 'Non-Consumable'; }), backgroundColor: _selectedType == 'Non-Consumable' ? Color(0xFF08B797) : Colors.grey[300], child: Icon(Icons.build), tooltip: 'Non-Consumable'),
          SizedBox(height: 10),
          FloatingActionButton(onPressed: () => setState(() { _selectedType = 'All'; }), backgroundColor: _selectedType == 'All' ? Color(0xFF08B797) : Colors.grey[300], child: Icon(Icons.select_all), tooltip: 'All'),
          SizedBox(height: 10),
          FloatingActionButton(onPressed: () => setState(() { _selectedType = 'Low Stock'; }), backgroundColor: _selectedType == 'Low Stock' ? Color(0xFF08B797) : Colors.grey[300], child: Icon(Icons.warning), tooltip: 'Low Stock'),
        ],
      ),
    );
  }

  Widget _buildInventoryItemCard(InventoryItem item) {
    final TextEditingController _restockController = TextEditingController();

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text('${item.name}, ${item.quantity}, ${item.unit}, ${item.type}'),
        subtitle: Text('Quantity: ${item.quantity}, ${item.unit}'),
        trailing: IconButton(
          icon: Icon(Icons.add, color: Colors.green),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Restock ${item.name}'),
                  content: TextField(
                    controller: _restockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Additional Quantity'),
                  ),
                  actions: [
                    TextButton(child: Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                    ElevatedButton(
                      child: Text('Restock'),
                      onPressed: () {
                        int additionalQuantity = int.tryParse(_restockController.text) ?? 0;
                        if (additionalQuantity > 0) {
                          _restockItem(item, additionalQuantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item Restocked Successfully!')),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemForm() {
    return Column(
      children: [
        TextField(controller: _itemNameController, decoration: InputDecoration(labelText: 'Item Name', border: OutlineInputBorder())),
        SizedBox(height: 10),
        TextField(controller: _itemQuantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Item Quantity', border: OutlineInputBorder())),
        SizedBox(height: 10),
        TextField(controller: _itemUnitController, decoration: InputDecoration(labelText: 'Unit (e.g., kg, liters)', border: OutlineInputBorder())),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _itemType,
          items: ['Consumable', 'Non-Consumable'].map((String type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          onChanged: (value) {
            setState(() {
              _itemType = value!;
            });
          },
          decoration: InputDecoration(labelText: 'Item Type'),
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: _addItem, child: Text('Add Item')),
      ],
    );
  }
}
