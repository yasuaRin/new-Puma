import 'package:flutter/material.dart';
import 'package:puma_is/controllers/EventController.dart';
import 'package:puma_is/models/event_model.dart';
import 'package:puma_is/services/event_services.dart';


class ManageEventPage extends StatefulWidget {
  @override
  _ManageEventPageState createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final EventController _eventController = EventController();
  final TextEditingController _eventIDController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;

  // To clear input fields after submission
  void _clearFields() {
    _eventIDController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    setState(() {
      _selectedDate = null;
    });
  }

  // Handle Event Action (Create or Update)
  void _handleEventAction({String? eventId}) {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields and select a date")),
      );
      return;
    }

    EventModel event = EventModel(
      eventID: _eventIDController.text, // Manually added eventID
      name: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      date: _selectedDate.toString(),
      isUpcoming: true, // Flag to indicate event is upcoming
    );

    if (eventId == null) {
      _eventController.createEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event added successfully")));
    } else {
      _eventController.updateEvent(event, eventId); // Use eventId for updating
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event updated successfully")));
    }

    _clearFields(); // Clear fields after submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventIDController,
              decoration: InputDecoration(labelText: "Event ID"),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Event Name"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Event Description"),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Event Location"),
            ),
            // Date Picker (example)
            ListTile(
              title: Text(_selectedDate == null ? 'Select Date' : _selectedDate.toString()),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () => _handleEventAction(),
              child: Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }
}
