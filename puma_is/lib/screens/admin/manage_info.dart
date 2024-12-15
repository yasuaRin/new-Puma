import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/controllers/InfoController.dart';

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

  List<DocumentSnapshot> _infoList = [];
  String? _selectedInfoId;

  final ScrollController _scrollController = ScrollController();

  // Fetching info from Firestore
  void _fetchInfo() async {
    var info = await FirebaseFirestore.instance.collection('info').get();
    setState(() {
      _infoList = info.docs;
    });
  }

  // Handling add/update operation
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

    _clearFields();
    _fetchInfo();
  }

  // Deleting an info item
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

  // Clearing input fields
  void _clearFields() {
    _titleController.clear();
    _contentController.clear();
    _contactPersonController.clear();
    setState(() {
      _selectedDate = null;
      _selectedInfoId = null;
    });
  }

  // Initializing state
  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color buttonTextColor = Colors.black;
    Color appBarTextColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
    Color appBarColor = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    Color backgroundColor = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  Color cardColor = Theme.of(context).brightness == Brightness.dark
  ? Colors.grey[800]! 
  : Color(0xFFF2F2F2);  // Custom light gray/white shade

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ), // First warning icon with dynamic color
              const SizedBox(width: 8),
              Text(
                'Manage Info',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: appBarTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.warning_amber_outlined,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ), // Second warning icon with dynamic color
            ],
          ),
        ),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
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
                  color: cardColor, // Set card color to dynamic
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _selectedInfoId == null ? 'Add Info' : 'Update Info',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(color: Colors.black),  // Set the label text color to black
                            hintText: 'Enter title',
                            hintStyle: TextStyle(color: textColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            labelText: 'Content',
                            labelStyle: TextStyle(color: Colors.black),  // Set the label text color to black
                            hintText: 'Enter content',
                            hintStyle: TextStyle(color: textColor),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _contactPersonController,
                          decoration: InputDecoration(
                            labelText: 'Contact Person',
                            labelStyle: TextStyle(color: Colors.black),  // Set the label text color to black
                            hintText: 'Enter contact person',
                            hintStyle: TextStyle(color: textColor),
                            filled: true,
                            fillColor: Colors.white,
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
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? "Pick Date"
                                : "${_selectedDate!.toLocal()}".split(' ')[0],
                            style: TextStyle(color: Colors.black), // Set text color to black
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _handleInfoAction(infoId: _selectedInfoId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            _selectedInfoId == null ? 'Add Info' : 'Update Info',
                            style: TextStyle(color: Colors.black), // Set text color to black
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Info List',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _infoList.length,
                  itemBuilder: (context, index) {
                    var info = _infoList[index];
                    return Card(
                      color: cardColor, // Set card color to dynamic
                      child: ListTile(
                        title: Text(info['title'], style: TextStyle(color: textColor)),
                        subtitle: Text(info['contactPerson'], style: TextStyle(color: textColor)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedInfoId = info.id;
                                  _titleController.text = info['title'];
                                  _contentController.text = info['content'];
                                  _contactPersonController.text = info['contactPerson'];
                                  _selectedDate = (info['date'] as Timestamp).toDate();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.red
                                    : Colors.red,
                              ),
                              onPressed: () => _deleteInfo(info.id),
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
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_upward, color: Colors.black),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_downward, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
