import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageEventPage extends StatefulWidget {
  @override
  _ManageEventPageState createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final TextEditingController _event_IDController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  DateTime? _selectedDate;

  List<DocumentSnapshot> _eventList = [];
  String? _selectedEvent_ID;

  // Fetch Events from Firebase
  void _fetchEvent() async {
    var event = await FirebaseFirestore.instance.collection('events').get();
    setState(() {
      _eventList = event.docs;
    });
  }

  // Handle Create/Update Event
  void _handleEventAction({String? event_ID}) async {
    if (_event_IDController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and select a date")),
      );
      return;
    }

    Map<String, dynamic> eventData = {
      'event_ID': _event_IDController.text,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'Status': _statusController.text,
      'date': _selectedDate,
    };

    try {
      if (event_ID == null) {
        // Add Event
        await FirebaseFirestore.instance.collection('events').add(eventData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event added successfully")));
      } else {
        // Update Event
        await FirebaseFirestore.instance
            .collection('events')
            .doc(event_ID)
            .update(eventData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event updated successfully")));
      }
      _clearFields();
      _fetchEvent();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving event: $e")));
    }
  }

  // Delete Event with Confirmation
  void _deleteEvent(String event_ID) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(event_ID)
            .delete();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Event deleted successfully")));
        _fetchEvent();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error deleting event: $e")));
      }
    }
  }

  // Clear Input Fields
  void _clearFields() {
    _event_IDController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _statusController.clear();
    setState(() {
      _selectedDate = null;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Event'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card with form fields
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
                      _selectedEvent_ID == null ? 'Add Event' : 'Update Event',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _event_IDController,
                      decoration: InputDecoration(labelText: 'Event_ID'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                   
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _statusController,
                      decoration: InputDecoration(labelText: 'Status'),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                      },
                      child: Text("Pick Date"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleEventAction(event_ID: _selectedEvent_ID);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: Text(
                        _selectedEvent_ID == null
                            ? 'Add Event'
                            : 'Update Event',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Event List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _eventList.length,
              itemBuilder: (context, index) {
                var event = _eventList[index];
                return ListTile(
                  title: Text(event['title']),
                  subtitle: Text(event['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          _event_IDController.text = event['event_ID'];
                          _titleController.text = event['title'];
                          _descriptionController.text = event['description'];
                          _locationController.text = event['location'];
                          _statusController.text = event['Status'];
                          setState(() {
                            _selectedDate =
                                (event['date'] as Timestamp).toDate();
                            _selectedEvent_ID = event.id;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteEvent(event.id);
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
