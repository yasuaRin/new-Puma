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

  List<DocumentSnapshot> _memberList = [];
  String? _selectedMemberId;

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
        _positionController.text.isEmpty) {
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
    setState(() {
      _selectedMemberId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Management'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      _selectedMemberId == null ? 'Add Member' : 'Update Member',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _batchController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Batch',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _positionController,
                      decoration: InputDecoration(
                        labelText: 'Position',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleMemberAction(memberId: _selectedMemberId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _selectedMemberId == null ? 'Add Member' : 'Update Member',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Member List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _memberList.length,
              itemBuilder: (context, index) {
                var member = _memberList[index];
                return ListTile(
                  title: Text(member['fullName']),
                  subtitle: Text('Batch: ${member['batch']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          setState(() {
                            _selectedMemberId = member.id;
                            _fullNameController.text = member['fullName'];
                            _batchController.text = member['batch'].toString();
                            _positionController.text = member['position'];
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMember(member.id),
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
