import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user.dart';
import '../dashboard/farmer_dash.dart';
import '../dashboard/supervisor_dash.dart';
import '../dashboard/warehouse_dash.dart';
import 'forgot_password.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // Open the Hive box to fetch user data
      var userBox = await Hive.openBox<User>('users');

      // Find the user with the given email and password
      final user = userBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => User(email: '', password: '', role: '', firstName: '', lastName: '', phoneNumber: '', farmName: '', location: '', name: ''),
      );

      if (user.email.isNotEmpty)  {
        // Navigate to user role-specific page based on their role
        switch (user.role) {
          case 'Farm Manager':
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardPage()),
                );
            break;
          case 'Supervisor':
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupervisorDashboardPage()),
                );
            break;
          case 'Warehouse Staff':
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WarehouseStaffDashboardPage()),
                );
            break;
          default:
            _showErrorDialog('Invalid role');
            break;
        }
      } else {
        _showErrorDialog('Invalid email or password');
      }
    }
  }

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: 600, // Set a max width for the form container
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Message
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

                      // Login Icon
                      Center(
                        child: Icon(
                          Icons.login,
                          size: 48,
                          color: Color(0xFF08B797),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Email Field
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
                      SizedBox(height: 16.0),

                      // Password Field
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

                      // Login Button
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
                      SizedBox(height: 20),

                      // Navigation to Registration Page
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrationForm()),
                          );
                        },
                        child: Text('Don\'t have an account? Register'),
                      ),
                      SizedBox(height: 20),

                      // Forgot Password Link
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ],
                  ),
                );
              },
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
