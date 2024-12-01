import 'package:flutter/material.dart';

class SupervisorCropAndLivestockManagementPage extends StatefulWidget {
  @override
  _SupervisorCropAndLivestockManagementPage createState() =>
      _SupervisorCropAndLivestockManagementPage();
}

class _SupervisorCropAndLivestockManagementPage
    extends State<SupervisorCropAndLivestockManagementPage> {
  // Dummy data for demonstration purposes
  List<Map<String, String>> cropRecords = [];
  List<Map<String, String>> livestockRecords = [];

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
              if (cropRecords.isNotEmpty)
                _buildGroupCard('Crops', cropRecords),
              if (cropRecords.isEmpty)
                Center(
                  child: Text(
                    'No Crop records available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              SizedBox(height: 20),

              // Livestock Records
              if (livestockRecords.isNotEmpty)
                _buildGroupCard('Livestock', livestockRecords),
              if (livestockRecords.isEmpty)
                Center(
                  child: Text(
                    'No Livestock records available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
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
  Widget _buildGroupCard(String title, List<Map<String, String>> records) {
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
            SizedBox(height: 10),
            ...records.map((record) {
              return ListTile(
                title: Text(record.entries.first.value),
                subtitle: Text(record.entries.map((e) => '${e.key}: ${e.value}').join('\n')),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Method to show Add Dialog
  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: Text('Would you like to add a Crop or Livestock?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showInputForm(context, 'Crop');
              },
              child: Text('Crop'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showInputForm(context, 'Livestock');
              },
              child: Text('Livestock'),
            ),
          ],
        );
      },
    );
  }

  // Method to show the input form based on selection
  void _showInputForm(BuildContext context, String category) {
    String name = '';
    String detail1 = '';
    String detail2 = '';

    String field1 = category == 'Crop' ? 'Planting Date' : 'Breed';
    String field2 = category == 'Crop' ? 'Harvesting Date' : 'Feeding Schedule';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: category),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: field1),
                onChanged: (value) => detail1 = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: field2),
                onChanged: (value) => detail2 = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (category == 'Crop') {
                  setState(() {
                    cropRecords.add({
                      category: name,
                      field1: detail1,
                      field2: detail2,
                    });
                  });
                } else {
                  setState(() {
                    livestockRecords.add({
                      category: name,
                      field1: detail1,
                      field2: detail2,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
