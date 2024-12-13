import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/controllers/InfoController.dart';
import 'package:puma_is/services/info_services.dart';

class ManageInfoPage extends StatefulWidget {
  const ManageInfoPage({super.key});

  @override
  _ManageInfoPageState createState() => _ManageInfoPageState();
}

class _ManageInfoPageState extends State<ManageInfoPage> {
  final InfoController _infoController = InfoController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  DateTime? _selectedDate;

  List<DocumentSnapshot> _infoList = []; // List to store info from Firebase
  String? _selectedInfoId; // Track selected info for update

  // Fetch Info from Firebase
  void _fetchInfo() async {
    var info = await FirebaseFirestore.instance.collection('info').get();
    setState(() {
      _infoList = info.docs;
    });
  }

  // Handle Create/Update Info
  void _handleInfoAction({String? infoId}) {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _contactPersonController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields and select a date")),
      );
      return;
    }

    if (infoId == null) {
      _infoController.addInfo(
        title: _titleController.text,
        content: _contentController.text,
        dateTime: _selectedDate!,
        contactPerson: _contactPersonController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Info added successfully")));
    } else {
      _infoController.updateInfo(
        infoId: infoId,
        title: _titleController.text,
        content: _contentController.text,
        dateTime: _selectedDate!,
        contactPerson: _contactPersonController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Info updated successfully")));
    }

    // Clear fields and fetch updated info list
    _clearFields();
    _fetchInfo();
  }

  // Delete Info Button with confirmation dialog
  void _deleteInfo(String infoId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this info?'),
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
                await _infoController.deleteInfo(infoId);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Info deleted successfully")));
                _fetchInfo();
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error deleting info")));
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
    _titleController.clear();
    _contentController.clear();
    _contactPersonController.clear();
    setState(() {
      _selectedDate = null;
      _selectedInfoId = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInfo(); // Fetch info when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Info'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Management Card
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
                      _selectedInfoId == null ? 'Add Info' : 'Update Info',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: InputDecoration(
                        labelText: 'Contact Person',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                      },
                      child: const Text("Pick Date"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleInfoAction(infoId: _selectedInfoId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        _selectedInfoId == null ? 'Add Info' : 'Update Info',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Info List',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _infoList.length,
              itemBuilder: (context, index) {
                var info = _infoList[index];
                return ListTile(
                  title: Text(info['title']),
                  subtitle: Text(info['contactPerson']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          _titleController.text = info['title'];
                          _contentController.text = info['content'];
                          _contactPersonController.text = info['contactPerson'];
                          setState(() {
                            _selectedDate = (info['dateTime'] as Timestamp).toDate();
                            _selectedInfoId = info.id;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteInfo(info.id);
                        },
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
