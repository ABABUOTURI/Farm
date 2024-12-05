import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:flutter/material.dart';
import 'forgot_password.dart';
import 'registration_page.dart';
import '../dashboard/farmer_dash.dart';
import '../dashboard/supervisor_dash.dart';
import '../dashboard/warehouse_dash.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      try {
        // Ensure no cached user session
        if (_auth.currentUser != null) {
          await _auth.signOut(); // Sign out if a user is already signed in
        }

        // Authenticate with Firebase
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          await _fetchAndNavigate(userCredential.user!.uid);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _getFirebaseAuthError(e);
        _showErrorDialog(errorMessage);
      } catch (e) {
        _showErrorDialog('An unexpected error occurred: $e');
      }
    }
  }

  // Fetch user data and navigate to the respective dashboard
  Future<void> _fetchAndNavigate(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String userRole = userDoc['role'] ?? '';
        _navigateToDashboard(userRole);
      } else {
        _showErrorDialog('User data not found in the database');
      }
    } catch (e) {
      _showErrorDialog('Failed to fetch user data: $e');
    }
  }

  // Navigate to the respective dashboard based on the user's role
  void _navigateToDashboard(String role) {
    switch (role) {
      case 'Farm Manager':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 'Supervisor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SupervisorDashboardPage()),
        );
        break;
      case 'Warehouse Staff':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WarehouseStaffDashboardPage()),
        );
        break;
      default:
        _showErrorDialog('Invalid role assigned: $role');
        break;
    }
  }

  // Helper function to map FirebaseAuthException to user-friendly error messages
  String _getFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password entered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return 'An authentication error occurred. Please try again.';
    }
  }

  // Show error dialog with the given message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF08B797),
                  ),
                ),
                SizedBox(height: 20),
                Icon(
                  Icons.login,
                  size: 48,
                  color: Color(0xFF08B797),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08B797),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationForm()),
                    );
                  },
                  child: Text('Don\'t have an account? Register'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
