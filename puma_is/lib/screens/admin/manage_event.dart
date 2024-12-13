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
        _dateController.text.isEmpty ||
        _cpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields and select a date")),
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
        // Add Event
        await FirebaseFirestore.instance.collection('events').add(eventData);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Event added successfully")));
      } else {
        // Update Event
        await FirebaseFirestore.instance
            .collection('events')
            .doc(event_ID)
            .update(eventData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event updated successfully")));
      }
      _clearFields();
      _fetchEvent();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving event: $e")));
    }
  }

  // Delete Event with Confirmation
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
        await FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event deleted successfully")));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Event'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _selectedEvent_ID == null ? 'Add Event' : 'Update Event',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _event_IDController,
                      decoration: const InputDecoration(labelText: 'Event_ID'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _cpController,
                      decoration: const InputDecoration(labelText: 'cp'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _dateController,
                      decoration:
                          const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _handleEventAction(event_ID: _selectedEvent_ID);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      child: Text(
                        _selectedEvent_ID == null
                            ? 'Add Event'
                            : 'Update Event', // This will display "Update Event" when editing an event
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
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
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: () {
                          _event_IDController.text = event['event_ID'];
                          _titleController.text = event['title'];
                          _descriptionController.text = event['description'];
                          _locationController.text = event['location'];
                          _statusController.text = event['Status'];
                          _cpController.text = event['cp'];
                          _dateController.text =
                              event['date']; // Directly use the date string
                          setState(() {
                            _selectedEvent_ID = event.id;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
