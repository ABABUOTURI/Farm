import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/user.dart';
import 'login_page.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController farmNameController = TextEditingController();

  String selectedRole = 'Farm Manager';
  String selectedLocation = 'Select Region';
  bool agreeToTerms = false;

  // List of roles for dropdown
  final List<String> roles = [
    'Farm Manager',
    'Supervisor',
    'Warehouse Staff'
  ];

  // List of locations for dropdown
  final List<String> locations = [
    'Select Region',
    'North',
    'South',
    'East',
    'West'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 600, // Set a max width for the form container
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(firstNameController, 'First Name', 'Please enter your first name'),
                      SizedBox(height: 16.0),
                      _buildTextField(lastNameController, 'Last Name', 'Please enter your last name'),
                      SizedBox(height: 16.0),
                      _buildEmailField(emailController),
                      SizedBox(height: 16.0),
                      _buildTextField(phoneNumberController, 'Phone Number', null, keyboardType: TextInputType.phone),
                      SizedBox(height: 16.0),

                      // Account Details Section
                      DropdownButtonFormField(
                        value: selectedRole,
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'User Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value.toString();
                          });
                        },
                      ),
                      SizedBox(height: 16.0),
                      _buildTextField(passwordController, 'Password', 'Password must be at least 6 characters', obscureText: true),
                      SizedBox(height: 16.0),
                      _buildTextField(confirmPasswordController, 'Confirm Password', 'Passwords do not match', obscureText: true),
                      SizedBox(height: 16.0),

                      // Farm/Organization Details
                      _buildTextField(farmNameController, 'Farm/Organization Name', 'Please enter the farm or organization name'),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField(
                        value: selectedLocation,
                        items: locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Location (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value.toString();
                          });
                        },
                      ),
                      SizedBox(height: 16.0),

                      // Security and Verification
                      CheckboxListTile(
                        title: Text('Agree to Terms and Conditions'),
                        value: agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            agreeToTerms = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      // Register Button
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF08B797),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() && agreeToTerms) {
                              _registerUser();
                            } else if (!agreeToTerms) {
                              _showAlertDialog('Terms Not Agreed', 'You must agree to the terms and conditions to register.');
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),

                      // Footer Section
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    var userBox = await Hive.openBox<User>('users');

    // Create a new user object
    final user = User(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      password: passwordController.text,
      role: selectedRole,
      farmName: farmNameController.text,
      location: selectedLocation, name: '',
    );

    // Save the user to Hive
    await userBox.add(user);

    // Show success message and navigate to Login Page
    _showAlertDialog('Registration Successful', 'Your account has been created.').then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    // Clear form fields
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    farmNameController.clear();
    setState(() {
      selectedRole = 'Farm Manager';
      selectedLocation = 'Select Region';
      agreeToTerms = false;
    });
  }

  Future<void> _showAlertDialog(String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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

  TextFormField _buildTextField(TextEditingController controller, String label, String? errorMessage, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: errorMessage != null ? (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      } : null,
    );
  }

  TextFormField _buildEmailField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Regular expression for validating email
        String pattern = r'^[^@]+@[^@]+\.[^@]+';
        if (!RegExp(pattern).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
