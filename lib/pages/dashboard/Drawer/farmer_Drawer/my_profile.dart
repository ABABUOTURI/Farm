// my_profile_page.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String? userName; // User's initials fetched from Hive
  String? email;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the page loads
  }

  // Fetch user details from Hive
  void _fetchUserDetails() async {
    var box = await Hive.openBox('userBox'); // Open the Hive box
    setState(() {
      userName = box.get('userName') ?? 'N/A'; // Fetch the user's initials
      email = box.get('userEmail') ?? 'N/A'; // Fetch the user's email
      phoneNumber = box.get('userPhone') ?? 'N/A'; // Fetch the user's phone number
    });
  }

  // Save updated details to Hive
  void _saveUserDetails(String newName, String newEmail, String newPhone) async {
    var box = await Hive.openBox('userBox');
    await box.put('userName', newName); // Save the updated initials
    await box.put('userEmail', newEmail); // Save the updated email
    await box.put('userPhone', newPhone); // Save the updated phone number

    // Update the state to reflect changes
    setState(() {
      userName = newName;
      email = newEmail;
      phoneNumber = newPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Added space to accommodate AppBar height

              // User Information Section
              Text(
                'User Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildProfileInfoCard('Name', userName ?? 'N/A', Icons.person),
              _buildProfileInfoCard('Email', email ?? 'N/A', Icons.email),
              _buildProfileInfoCard('Phone', phoneNumber ?? 'N/A', Icons.phone),
              SizedBox(height: 20),

              // Edit Profile Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showEditProfileDialog(context);
                  },
                  child: Text('Edit Profile'),
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

  // Method to build profile info card
  Widget _buildProfileInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Color(0xFF08B797)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show edit profile dialog
  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the updated details and close the dialog
                _saveUserDetails(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF08B797),
              ),
            ),
          ],
        );
      },
    );
  }
}
