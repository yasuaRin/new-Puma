import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/controllers/UserController.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

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

  final ScrollController _scrollController = ScrollController(); // ScrollController for managing scroll position

  // Fetch Users from Firebase and order by fullName
  void _fetchUsers() async {
    var users = await FirebaseFirestore.instance
        .collection('user')
        .orderBy('fullName') // Sort users by fullName
        .get();
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
        const SnackBar(content: Text("Please fill in all fields and agree to terms")),
      );
      return;
    }

    // Password strength validation (e.g., at least 8 characters, one special character)
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters long")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
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
          .showSnackBar(const SnackBar(content: Text("User created successfully")));
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
          .showSnackBar(const SnackBar(content: Text("User updated successfully")));
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
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _userController.deleteUser(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User deleted successfully")));
                _fetchUsers(); // Fetch updated user list after deletion
                Navigator.of(context).pop(); // Close the dialog
              } catch (e) {
                print('Error deleting user: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error deleting user")));
              }
            },
            child: const Text('Delete'),
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
        title: const Text('User Management'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the ScrollController
        padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _selectedUserId == null ? 'Add User' : 'Update User',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _IDController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        labelStyle: const TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Full Name Input Field
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password Input Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password Input Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    // Terms and Conditions Checkbox
                    CheckboxListTile(
                      title: const Text('I agree to the terms and conditions'),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleUserAction(userId: _selectedUserId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _selectedUserId == null ? 'Add User' : 'Update User',
                        style: const TextStyle(
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
            const SizedBox(height: 30),
            const Text(
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
                        icon: const Icon(Icons.edit, color: Colors.teal),
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
                        icon: const Icon(Icons.delete, color: Colors.red),
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
      // Floating Action Buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
            backgroundColor: Colors.teal,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_downward),
            backgroundColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
