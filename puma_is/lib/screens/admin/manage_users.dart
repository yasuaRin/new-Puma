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
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _termsCondition = false;

  List<DocumentSnapshot> _userList = [];
  String? _selectedUserId;

  final ScrollController _scrollController = ScrollController();

  void _fetchUsers() async {
    var users = await FirebaseFirestore.instance
        .collection('user')
        .orderBy('fullName')
        .get();
    setState(() {
      _userList = users.docs;
    });
  }

  void _handleUserAction({String? userId}) {
    if (_IDController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        !_termsCondition) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields and agree to terms")),
      );
      return;
    }

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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User created successfully")));
    } else {
      _userController.updateUser(
        userId: userId,
        ID: _IDController.text,
        email: _emailController.text,
        fullName: _fullNameController.text,
        password: _passwordController.text,
        termsCondition: _termsCondition,
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User updated successfully")));
    }

    _clearFields();
    _fetchUsers();
  }

  void _deleteUser(String userId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _userController.deleteUser(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User deleted successfully")));
                _fetchUsers();
                Navigator.of(context).pop();
              } catch (e) {
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

  void _clearFields() {
    _IDController.clear();
    _emailController.clear();
    _fullNameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _termsCondition = false;
      _selectedUserId = null;
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color boxColor = isDarkMode ? Colors.grey[800] ?? Colors.black : Colors.grey[200] ?? Colors.white;
    Color buttonColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              'User Management',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.warning,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _selectedUserId == null ? 'Add User' : 'Update User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(_IDController, 'ID', textColor),
                    const SizedBox(height: 10),
                    _buildTextFormField(_emailController, 'Email', textColor),
                    const SizedBox(height: 10),
                    _buildTextFormField(_fullNameController, 'Full Name', textColor),
                    const SizedBox(height: 10),
                    _buildTextFormField(_passwordController, 'Password', textColor, obscureText: true),
                    const SizedBox(height: 10),
                    _buildTextFormField(_confirmPasswordController, 'Confirm Password', textColor, obscureText: true),
                    const SizedBox(height: 15),
                    CheckboxListTile(
                      title: Text(
                        'I agree to the terms and conditions',
                        style: TextStyle(color: textColor),
                      ),
                      value: _termsCondition,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsCondition = value!;
                        });
                      },
                      activeColor: textColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleUserAction(userId: _selectedUserId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.white : Colors.black, 
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _selectedUserId == null ? 'Add User' : 'Update User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.black : Colors.white, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Users List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = _userList[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.grey[800], 
                  child: ListTile(
                    title: Text(user['fullName'], style: TextStyle(color: Colors.white)), 
                    subtitle: Text(user['email'], style: TextStyle(color: Colors.white)), 
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _selectedUserId = user.id;
                              _IDController.text = user['ID'];
                              _emailController.text = user['email'];
                              _fullNameController.text = user['fullName'];
                             
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteUser(user.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _scrollToTop,
            backgroundColor: Colors.white,
            child: const Icon(Icons.arrow_upward, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _scrollToBottom,
            backgroundColor: Colors.white,
            child: const Icon(Icons.arrow_downward, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, Color textColor, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),  
        filled: true,
        fillColor: Colors.white, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
