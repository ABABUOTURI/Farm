// settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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

              // User Preferences Section
              Text(
                'User Preferences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPreferenceSettingCard('Notification Settings', 'Manage your notification preferences'),
              _buildPreferenceSettingCard('Language', 'Select your preferred language'),
              SizedBox(height: 20),

              // Theme Customization Section
              Text(
                'Theme Customization',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildThemeSettingCard('System Theme', 'Choose between light and dark mode'),
              _buildThemeSettingCard('Primary Color', 'Select the primary color for the app'),
              SizedBox(height: 20),

              // System Settings Section (restricted to Farm Manager)
              Text(
                'System Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildSystemSettingCard('Data Backup', 'Configure backup settings'),
              _buildSystemSettingCard('Manage User Roles', 'Edit user roles and permissions', isRestricted: true),
              SizedBox(height: 20),

              // Save Changes Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Settings saved successfully!')),
                    );
                  },
                  child: Text('Save Changes'),
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

  // Method to build preference setting card
  Widget _buildPreferenceSettingCard(String title, String description) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF08B797)),
          ],
        ),
      ),
    );
  }

  // Method to build theme setting card
  Widget _buildThemeSettingCard(String title, String description) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF08B797)),
          ],
        ),
      ),
    );
  }

  // Method to build system setting card (with optional restriction)
  Widget _buildSystemSettingCard(String title, String description, {bool isRestricted = false}) {
    return Card(
      elevation: 2,
      color: isRestricted ? Colors.grey.shade300 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isRestricted ? Colors.grey : Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(description, style: TextStyle(color: isRestricted ? Colors.grey : Colors.black)),
                ],
              ),
            ),
            if (!isRestricted)
              Icon(Icons.arrow_forward_ios, color: Color(0xFF08B797)),
          ],
        ),
      ),
    );
  }
}
