// user_management_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';


class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  late Box<User> userBox;

  // Available roles
  final List<String> roles = [
    'Farm Manager',
    'Supervisor',
    'Warehouse Staff',
  ];

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Farm Manager';

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<User>('usersBox');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Color(0xFF08B797),
      ),
      backgroundColor: Color(0xFFEEEDEA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddEditUserDialog(context);
              },
              child: Text('Add User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF08B797),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: userBox.listenable(),
                builder: (context, Box<User> box, _) {
                  if (box.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      User? user = box.getAt(index);
                      return ListTile(
                        title: Text(user?.name ?? 'No Name'),
                        subtitle: Text('${user?.email} - ${user?.role}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showAddEditUserDialog(context, index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to add or edit user
  void _showAddEditUserDialog(BuildContext context, [int? index]) {
    if (index != null) {
      User? user = userBox.getAt(index);
      _nameController.text = user?.name ?? '';
      _emailController.text = user?.email ?? '';
      _selectedRole = user?.role ?? roles[0];
    } else {
      _nameController.clear();
      _emailController.clear();
      _selectedRole = roles[0];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Add User' : 'Edit User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: roles.map<DropdownMenuItem<String>>((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Role'),
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
                if (index == null) {
                  _addUser();
                } else {
                  _editUser(index);
                }
                Navigator.of(context).pop();
              },
              child: Text(index == null ? 'Add' : 'Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF08B797),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add new user
  void _addUser() {
    final newUser = User(
      name: _nameController.text,
      email: _emailController.text,
      role: _selectedRole, firstName: '', lastName: '', phoneNumber: '', password: '', farmName: '', location: '',
    );
    userBox.add(newUser);
  }

  // Edit existing user
  void _editUser(int index) {
    final updatedUser = User(
      name: _nameController.text,
      email: _emailController.text,
      role: _selectedRole, firstName: '', lastName: '', phoneNumber: '', password: '', farmName: '', location: '',
    );
    userBox.putAt(index, updatedUser);
  }

  // Delete user
  void _deleteUser(int index) {
    userBox.deleteAt(index);
  }
}
