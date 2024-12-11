import 'package:flutter/material.dart';
import 'package:puma_is/controllers/EventController.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure you have this import for Timestamp

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventController _controller = EventController();
  List<Map<String, dynamic>> _eventList = [];
  List<Map<String, dynamic>> _filteredEventList = [];
  String _filter = 'All'; // Default filter (All events)

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
  }

  // Fetch all events
  void _fetchAllEvents() async {
    try {
      List<Map<String, dynamic>> data = await _controller.fetchAllEvent();
      setState(() {
        _eventList = data;
        _filteredEventList = data; // Initially display all events
      });
    } catch (error) {
      _showErrorDialog("Error fetching events: $error");
    }
  }

  // Filter events based on past or upcoming
  void _filterEvents() {
    if (_filter == 'Upcoming') {
      setState(() {
        _filteredEventList = _eventList.where((event) {
          DateTime eventDate = event['dateTime'] is Timestamp
              ? (event['dateTime'] as Timestamp).toDate()
              : DateTime.now();
          return eventDate.isAfter(DateTime.now()); // Upcoming events
        }).toList();
      });
    } else if (_filter == 'Past') {
      setState(() {
        _filteredEventList = _eventList.where((event) {
          DateTime eventDate = event['dateTime'] is Timestamp
              ? (event['dateTime'] as Timestamp).toDate()
              : DateTime.now();
          return eventDate.isBefore(DateTime.now()); // Past events
        }).toList();
      });
    } else {
      setState(() {
        _filteredEventList = _eventList; // Show all events
      });
    }
  }

  // Dialog to show error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Page"),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text("All Events"),
                        onTap: () {
                          setState(() {
                            _filter = 'All';
                          });
                          _filterEvents();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Upcoming Events"),
                        onTap: () {
                          setState(() {
                            _filter = 'Upcoming';
                          });
                          _filterEvents();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Past Events"),
                        onTap: () {
                          setState(() {
                            _filter = 'Past';
                          });
                          _filterEvents();
                          Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the info list or a message if no data
            Expanded(
              child: _filteredEventList.isEmpty
                  ? Center(
                      child: Text(
                        "No events available.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredEventList.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEventList[index];
                        final eventDate = event['dateTime'] is Timestamp
                            ? (event['dateTime'] as Timestamp).toDate()
                            : DateTime.now();

                        // If event['dateTime'] is null, show 'Date not available'
                        if (eventDate == null) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 5,
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                event['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              subtitle: Text('Date not available'),
                            ),
                          );
                        }

                        // Define status color based on event date
                        final bool isPastEvent = eventDate.isBefore(DateTime.now());
                        Color statusColor = isPastEvent ? Colors.red : Colors.green;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 5,
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(
                              isPastEvent ? Icons.history : Icons.event,
                              color: statusColor,
                            ),
                            title: Text(
                              event['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.deepPurple,
                              ),
                            ),
                             
                            subtitle: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Image.asset('assets/images/temuAlumni.jpeg'), // Add your image path here
                                  Text("Description: ${event['description']}"),
                                  Text("Location: ${event['location']}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isPastEvent ? 'Past' : 'Upcoming',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Date: ${eventDate.toLocal()}", // Display the converted date
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
