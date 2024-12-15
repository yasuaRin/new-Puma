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
        // Add Event
        await FirebaseFirestore.instance.collection('events').add(eventData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event added successfully")));
      } else {
        // Update Event
        await FirebaseFirestore.instance.collection('events').doc(event_ID).update(eventData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event updated successfully")));
      }
      _clearFields();
      _fetchEvent();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving event: $e")));
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
        await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event deleted successfully")));
        _fetchEvent();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting event: $e")));
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
    // Get the current theme to adjust colors
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color buttonColor = isDarkMode ? Colors.white : Colors.black;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color boxColor = isDarkMode ? Colors.black : Colors.white; 
    Color textFieldBackgroundColor = isDarkMode ? Colors.white : Colors.white; 
    Color borderColor = isDarkMode ? Colors.black : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Set the background color to black for the entire page in dark mode
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // Set app bar color based on the theme
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning, // Warning icon
                color: isDarkMode ? Colors.white : Colors.black, // Set icon color based on dark mode
              ),
              const SizedBox(width: 8), // Space between icon and text
              Text(
                'Manage Event',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 8), // Space between text and icon
              Icon(
                Icons.warning, // Warning icon
                color: isDarkMode ? Colors.white : Colors.black, // Set icon color based on dark mode
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController, // Attach scroll controller
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card container with form fields
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(8.0),
                  color: boxColor, // Set background color based on theme (black in dark mode)
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
                        _buildTextField(_event_IDController, 'Event ID', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_titleController, 'Title', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_descriptionController, 'Description', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_locationController, 'Location', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_statusController, 'Status', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_cpController, 'Contact Person', borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 15),
                        _buildTextField(_dateController, 'Date (YYYY-MM-DD)', isDate: true, borderColor: borderColor, backgroundColor: textFieldBackgroundColor),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _handleEventAction(event_ID: _selectedEvent_ID);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: buttonColor), // Adjust button color
                          child: Text(
                            _selectedEvent_ID == null ? 'Add Event' : 'Update Event', // This will display "Update Event" when editing an event
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
                    return ListTile(
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
                            icon: Icon(Icons.edit, color: buttonColor), // Adjust icon color
                            onPressed: () {
                              _event_IDController.text = event['event_ID'];
                              _titleController.text = event['title'];
                              _descriptionController.text = event['description'];
                              _locationController.text = event['location'];
                              _statusController.text = event['Status'];
                              _cpController.text = event['cp'];
                              _dateController.text = event['date'];
                              setState(() {
                                _selectedEvent_ID = event.id;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: buttonColor), // Adjust icon color
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
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                   backgroundColor: isDarkMode ? Colors.white : Colors.teal,
                  child: Icon(Icons.arrow_upward),
                  
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
            backgroundColor: isDarkMode ? Colors.white : Colors.teal,
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TextField builder to reuse the code for each input field
  Widget _buildTextField(TextEditingController controller, String label, {bool isDate = false, Color? borderColor, Color? backgroundColor}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDarkMode ? Colors.black : Colors.black), // Set text color to black for dark mode
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: borderColor),
        fillColor: backgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor ?? Colors.grey),
        ),
      ),
      keyboardType: isDate ? TextInputType.datetime : TextInputType.text,
    );
  }
}
