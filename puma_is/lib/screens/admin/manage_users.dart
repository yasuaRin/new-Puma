import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/controllers/UserController.dart';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final UserController _userController = UserController();
  final TextEditingController _IDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _termsCondition = false;

  List<DocumentSnapshot> _userList = []; // List to store users from Firebase
  String? _selectedUserId; // Track selected user for update

  // Fetch Users from Firebase
  void _fetchUsers() async {
    var users = await FirebaseFirestore.instance.collection('user').get();
    setState(() {
      _userList = users.docs;
    });
  }

  // Handle Create/Update User
  void _handleUserAction({String? userId}) {
    if (_IDController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _termsCondition == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and agree to terms")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (userId == null) {
      _userController.createUser(
        ID: _IDController.text,
        email: _emailController.text,
        fullName: _fullNameController.text,
        password: _passwordController.text,
        termsCondition: _termsCondition,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User created successfully")));
    } else {
      _userController.updateUser(
        userId: userId,
        ID: _IDController.text,
        email: _emailController.text,
        fullName: _fullNameController.text,
        password: _passwordController.text,
        termsCondition: _termsCondition,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User updated successfully")));
    }

    // Clear fields and fetch updated user list
    _clearFields();
    _fetchUsers();
  }

  // Delete User Button with confirmation dialog
  void _deleteUser(String userId) async {
    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _userController.deleteUser(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User deleted successfully")));
                _fetchUsers(); // Fetch updated user list after deletion
                Navigator.of(context).pop(); // Close the dialog
              } catch (e) {
                print('Error deleting user: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting user")));
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Clear input fields
  void _clearFields() {
    _IDController.clear();
    _emailController.clear();
    _fullNameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _termsCondition = false;
      _selectedUserId = null; // Reset selected user ID after action
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Information Card for Create or Update
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _selectedUserId == null ? 'Add User' : 'Update User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _IDController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        labelStyle: TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Full Name Input Field
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Password Input Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 15),

                    // Confirm Password Input Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 15),

                    // Terms and Conditions Checkbox
                    CheckboxListTile(
                      title: Text('I agree to the terms and conditions'),
                      value: _termsCondition,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsCondition = value!;
                        });
                      },
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Add or Update User Button
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleUserAction(userId: _selectedUserId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _selectedUserId == null ? 'Add User' : 'Update User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // User List (Read - Fetch from Firebase)
            SizedBox(height: 30),
            Text(
              'User List',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                var user = _userList[index];
                return ListTile(
                  title: Text(user['fullName']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Update Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          setState(() {
                            _selectedUserId = user.id;
                            _IDController.text = user['ID'];
                            _emailController.text = user['email'];
                            _fullNameController.text = user['fullName'];
                            _passwordController.text = user['password'];
                            _confirmPasswordController.text = user['password'];
                          });
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
