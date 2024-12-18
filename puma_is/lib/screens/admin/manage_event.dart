import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key});

  @override
  _ManageEventPageState createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final TextEditingController _event_IDController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();

  List<DocumentSnapshot> _eventList = [];
  String? _selectedEvent_ID;
  final ScrollController _scrollController = ScrollController();
  bool isDarkMode = false;

  void _fetchEvent() async {
    var event = await FirebaseFirestore.instance.collection('events').get();
    setState(() {
      _eventList = event.docs;
    });
  }

  void _handleEventAction({String? event_ID}) async {
    if (_event_IDController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _cpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and select a date")),
      );
      return;
    }

    String eventDate = _dateController.text;

    Map<String, dynamic> eventData = {
      'event_ID': _event_IDController.text,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'Status': _statusController.text,
      'date': eventDate,
      'cp': _cpController.text,
    };

    try {
      if (event_ID == null) {
        await FirebaseFirestore.instance.collection('events').add(eventData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event added successfully")));
      } else {
        await FirebaseFirestore.instance.collection('events').doc(event_ID).update(eventData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event updated successfully")));
      }
      _clearFields();
      _fetchEvent();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving event: $e")));
    }
  }

  void _deleteEvent(String eventId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event deleted successfully")));
        _fetchEvent();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting event: $e")));
      }
    }
  }

  void _clearFields() {
    _event_IDController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _statusController.clear();
    _dateController.clear();
    _cpController.clear();
    setState(() {
      _selectedEvent_ID = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  @override
  Widget build(BuildContext context) {

    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color buttonColor = isDarkMode ? Colors.white : Colors.black;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color boxColor = isDarkMode ? Colors.grey[800] ?? Colors.black : Colors.grey[200] ?? Colors.white;
    Color textFieldBackgroundColor = isDarkMode ? Colors.white : Colors.white;
    Color borderColor = isDarkMode ? Colors.black : Colors.black;
    Color labelColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white, 
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning, 
                color: isDarkMode ? Colors.white : Colors.black, 
              ),
              const SizedBox(width: 8), 
              Text(
                'Manage Event',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 8), 
              Icon(
                Icons.warning, 
                color: isDarkMode ? Colors.white : Colors.black, 
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController, 
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(8.0),
                  color: boxColor, 
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _selectedEvent_ID == null ? 'Add Event' : 'Update Event',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(_event_IDController, 'Event ID', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_titleController, 'Title', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_descriptionController, 'Description', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_locationController, 'Location', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_statusController, 'Status', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_cpController, 'Contact Person', labelColor: labelColor, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_dateController, 'Date (YYYY-MM-DD)', labelColor: labelColor, isDate: true, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _handleEventAction(event_ID: _selectedEvent_ID);
                          },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, 
                            foregroundColor: Colors.black, 
                          ),
                          child: Text(
                            _selectedEvent_ID == null ? 'Add Event' : 'Update Event',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Event List',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _eventList.length,
                  itemBuilder: (context, index) {
                    var event = _eventList[index];
                    return Card(
                      elevation: 5.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: boxColor, 
                      child: ListTile(
                        title: Text(
                          event['title'],
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          event['description'],
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: textColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _event_IDController.text = event['event_ID'];
                                  _titleController.text = event['title'];
                                  _descriptionController.text = event['description'];
                                  _locationController.text = event['location'];
                                  _statusController.text = event['Status'];
                                  _cpController.text = event['cp'];
                                  _dateController.text = event['date'];
                                  _selectedEvent_ID = event.id;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _deleteEvent(event.id);
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
          // Scroll Up button
          Positioned(
            right: 16,
            bottom: 100,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.black,
              ),
            ),
          ),
          // Scroll Down button
          Positioned(
            right: 16,
            bottom: 30,
            child: FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_downward,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isDate = false, Color? borderColor, Color? backgroundColor, Color? labelColor}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black), 
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: borderColor ?? Colors.black),
      ),
    ),
    keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
  );
}

  }
