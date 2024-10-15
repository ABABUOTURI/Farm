import 'package:flutter/material.dart';
import 'dart:async';

import 'login_page.dart'; // Required for Timer



class LoaderPage extends StatefulWidget {
  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  // Navigate to the login page after 5 seconds
  void _navigateToLogin() {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF08B797), // Loader page background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image displayed at the center
            ClipOval(
            child: Image.asset(
              'assets/gt.jpg', // Replace with your image path
              width: 300, // Adjust width as needed
              height: 300, // Adjust height as needed
              fit: BoxFit.cover, // Ensures the image covers the entire circle
            ),
          ),
            SizedBox(height: 20),
            // Loader widget
            CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD36643)), // Loader color
            ),
            SizedBox(height: 20),
            // Description text
            Text(
              'Preparing Your Farm Management Experience...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

