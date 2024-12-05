import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CropLivestockManagementPage extends StatefulWidget {
  @override
  _CropLivestockManagementPageState createState() =>
      _CropLivestockManagementPageState();
}

class _CropLivestockManagementPageState
    extends State<CropLivestockManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference crops = FirebaseFirestore.instance.collection('crops');
  CollectionReference livestock =
      FirebaseFirestore.instance.collection('livestock');
  String selectedType = 'Crops'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop & Livestock Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Records
              StreamBuilder<QuerySnapshot>(
                stream: crops.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Crop records available.'));
                  }
                  var cropData = snapshot.data!.docs;
                  return _buildGroupCard('Crops', cropData);
                },
              ),
              SizedBox(height: 20),

              // Livestock Records
              StreamBuilder<QuerySnapshot>(
                stream: livestock.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text('No Livestock records available.'));
                  }
                  var livestockData = snapshot.data!.docs;
                  return _buildGroupCard('Livestock', livestockData);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Color(0xFF08B797),
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to build a grouped card
  Widget _buildGroupCard(String title, List<DocumentSnapshot> records) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...records.map((record) => ListTile(
                  title: Text(record['name']),
                  subtitle: Text('Details: ${record['details']}'),
                )),
          ],
        ),
      ),
    );
  }

  // Method to show the dialog for adding new records
  void _showAddDialog(BuildContext context) {
    String name = '';
    String details = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Record'),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Details'),
              onChanged: (value) {
                details = value;
              },
            ),
            DropdownButton<String>(
              value: selectedType,
              items: ['Crops', 'Livestock']
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addRecord(name, details);
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Method to add new crop/livestock record
  void _addRecord(String name, String details) async {
    if (selectedType == 'Crops') {
      await crops.add({
        'name': name,
        'details': details,
      });
    } else if (selectedType == 'Livestock') {
      await livestock.add({
        'name': name,
        'details': details,
      });
    }
    setState(() {}); // Refresh the UI
  }
}
