import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ReportingPage extends StatefulWidget {
  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> tasksData = {};
  Map<String, dynamic> inventoryData = {};
  Map<String, dynamic> cropsData = {};
  Map<String, dynamic> livestockData = {};
  bool isDownloading = false; // Track downloading state

  @override
  void initState() {
    super.initState();
    _fetchTasksData();
    _fetchInventoryData();
    _fetchCropsData();
    _fetchLivestockData();
  }

  // Fetch tasks data from Firestore
  Future<void> _fetchTasksData() async {
    try {
      QuerySnapshot tasksSnapshot = await _firestore.collection('tasks').get();

      if (tasksSnapshot.docs.isNotEmpty) {
        setState(() {
          tasksData = {
            'Tasks Report': tasksSnapshot.docs.map((doc) {
              var task = doc.data() as Map<String, dynamic>;
              return 'Title: ${task['title']}, Deadline: ${task['deadline']}, Priority: ${task['priority']}, Status: ${task['status']}';
            }).join('\n'),
          };
        });
      } else {
        setState(() {
          tasksData = {'Tasks Report': 'No tasks available'};
        });
      }
    } catch (e) {
      print('Error fetching tasks data: $e');
      setState(() {
        tasksData = {'Tasks Report': 'Failed to load tasks data'};
      });
    }
  }

  // Fetch inventory data from Firestore
  Future<void> _fetchInventoryData() async {
    try {
      QuerySnapshot inventorySnapshot =
          await _firestore.collection('inventory').get();

      if (inventorySnapshot.docs.isNotEmpty) {
        setState(() {
          inventoryData = {
            'Inventory Report': inventorySnapshot.docs.map((doc) {
              var item = doc.data() as Map<String, dynamic>;
              return 'Item: ${item['name']}, Quantity: ${item['quantity']}, Price: ${item['price']}';
            }).join('\n'),
          };
        });
      } else {
        setState(() {
          inventoryData = {'Inventory Report': 'No inventory data available'};
        });
      }
    } catch (e) {
      print('Error fetching inventory data: $e');
      setState(() {
        inventoryData = {'Inventory Report': 'Failed to load inventory data'};
      });
    }
  }

  // Fetch crops data from Firestore
  Future<void> _fetchCropsData() async {
    try {
      QuerySnapshot cropsSnapshot = await _firestore.collection('crops').get();

      if (cropsSnapshot.docs.isNotEmpty) {
        setState(() {
          cropsData = {
            'Crops Report': cropsSnapshot.docs.map((doc) {
              var crop = doc.data() as Map<String, dynamic>;
              return 'Crop: ${crop['name']}, Details: ${crop['details']}';
            }).join('\n'),
          };
        });
      } else {
        setState(() {
          cropsData = {'Crops Report': 'No crops data available'};
        });
      }
    } catch (e) {
      print('Error fetching crops data: $e');
      setState(() {
        cropsData = {'Crops Report': 'Failed to load crops data'};
      });
    }
  }

  // Fetch livestock data from Firestore
  Future<void> _fetchLivestockData() async {
    try {
      QuerySnapshot livestockSnapshot =
          await _firestore.collection('livestock').get();

      if (livestockSnapshot.docs.isNotEmpty) {
        setState(() {
          livestockData = {
            'Livestock Report': livestockSnapshot.docs.map((doc) {
              var livestock = doc.data() as Map<String, dynamic>;
              return 'Livestock: ${livestock['name']}, Details: ${livestock['details']}';
            }).join('\n'),
          };
        });
      } else {
        setState(() {
          livestockData = {'Livestock Report': 'No livestock data available'};
        });
      }
    } catch (e) {
      print('Error fetching livestock data: $e');
      setState(() {
        livestockData = {'Livestock Report': 'Failed to load livestock data'};
      });
    }
  }

  // Build PDF document
  Future<File> _generatePdf(
      Map<String, dynamic> data, String reportTitle) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(reportTitle,
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text(
              data.values.join('\n'),
              style: pw.TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    ));

    // Save the PDF file to local storage
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$reportTitle.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Function to save PDF to device
  Future<void> _downloadReport(
      Map<String, dynamic> data, String reportTitle) async {
    setState(() {
      isDownloading = true; // Set downloading state to true
    });

    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final pdfFile = await _generatePdf(data, reportTitle);
        final directory = await getExternalStorageDirectory();
        final path = '${directory!.path}/$reportTitle.pdf';
        await pdfFile.copy(path);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report downloaded to $path')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading report: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission required!')),
      );
    }

    setState(() {
      isDownloading = false; // Reset downloading state after completion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Reports
              ...[
                {'data': tasksData, 'title': 'Tasks Report'},
                {'data': inventoryData, 'title': 'Inventory Report'},
                {'data': cropsData, 'title': 'Crops Report'},
                {'data': livestockData, 'title': 'Livestock Report'},
              ].map((report) {
                Map<String, dynamic> data =
                    report['data'] as Map<String, dynamic>;
                String title = report['title'] as String;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ...data.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: TextStyle(fontSize: 16)),
                          Text(entry.value.toString(),
                              style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (!isDownloading) {
                          _downloadReport(data, title);
                        }
                      },
                      child: isDownloading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Download $title'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF08B797),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
