import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/controllers/MemberController.dart';

class ManageMemberPage extends StatefulWidget {
  const ManageMemberPage({super.key});

  @override
  _ManageMemberPageState createState() => _ManageMemberPageState();
}

class _ManageMemberPageState extends State<ManageMemberPage> {
  final MemberController _memberController = MemberController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();

  List<DocumentSnapshot> _memberList = [];
  String? _selectedMemberId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    var members = await FirebaseFirestore.instance.collection('Members').get();
    setState(() {
      _memberList = members.docs;
    });
  }

  void _handleMemberAction({String? memberId}) async {
    if (_fullNameController.text.isEmpty ||
        _batchController.text.isEmpty ||
        _positionController.text.isEmpty ||
        _divisionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Ensure batch is numeric
    final int? batch = int.tryParse(_batchController.text);
    if (batch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Batch must be a valid number")),
      );
      return;
    }

    if (memberId == null) {
      await _memberController.addMember(
        fullName: _fullNameController.text,
        batch: batch,
        position: _positionController.text,
        division: _divisionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member created successfully")),
      );
    } else {
      await _memberController.updateMember(
        memberId: memberId,
        fullName: _fullNameController.text,
        batch: batch,
        position: _positionController.text,
        division: _divisionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member updated successfully")),
      );
    }

    _clearFields();
    _fetchUsers();
  }

  void _deleteMember(String memberId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _memberController.deleteMember(memberId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Member deleted successfully")),
              );
              _fetchUsers();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    _fullNameController.clear();
    _batchController.clear();
    _positionController.clear();
    _divisionController.clear();
    setState(() {
      _selectedMemberId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor, // Set the scaffold background color based on dark mode
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              SizedBox(width: 8),
              Text(
                'Member Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.warning,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: isDarkMode ? Colors.black : Colors.white, // Set background color for the body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: isDarkMode ? Colors.grey.shade800 : Color(0xFFF2F2F2), // equivalent to white with slight opacity (200), // Card background color
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _selectedMemberId == null ? 'Add Member' : 'Update Member',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          filled: true,
                          fillColor: Colors.white, // White fill color
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _batchController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Batch',
                          filled: true,
                          fillColor: Colors.white, // White fill color
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(
                          labelText: 'Position',
                          filled: true,
                          fillColor: Colors.white, // White fill color
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _divisionController,
                        decoration: InputDecoration(
                          labelText: 'Division',
                          filled: true,
                          fillColor: Colors.white, // White fill color
                          labelStyle: TextStyle(color: Colors.black),
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _handleMemberAction(memberId: _selectedMemberId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Set radius here to round the corners
                          ),
                        ),
                        child: Text(
                          _selectedMemberId == null ? 'Add Member' : 'Update Member',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Member List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _memberList.length,
                itemBuilder: (context, index) {
                  var member = _memberList[index];
                  return Card(
                   color: isDarkMode ? Colors.grey.shade800 : Color(0xFFF2F2F2), // equivalent to white with slight opacity (200), // Card background color
                    child: ListTile(
                      title: Text(member['fullName'], style: TextStyle(color: primaryColor)),
                      subtitle: Text(
                          'Batch: ${member['batch']}, Division: ${member['division']}',
                          style: TextStyle(color: primaryColor)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _selectedMemberId = member.id;
                                _fullNameController.text = member['fullName'];
                                _batchController.text = member['batch'].toString();
                                _positionController.text = member['position'];
                                _divisionController.text = member['division'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: isDarkMode ? Colors.red : Colors.red,
                            ),
                            onPressed: () {
                              _deleteMember(member.id);
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
      ),
      // Scroll Up and Scroll Down buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
              backgroundColor: Colors.white, // Floating button color (white)
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_downward),
              backgroundColor: Colors.white, // Floating button color (white)
            ),
          ],
        ),
      ),
    );
  }
}
