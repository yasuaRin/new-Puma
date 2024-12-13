import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<DocumentSnapshot> _upcomingEvents = [];
  List<DocumentSnapshot> _pastEvents = [];
  List<DocumentSnapshot> _allEvents = [];
  String _currentFilter = 'upcoming';
  
  // Map of event titles to their respective image paths
  final Map<String, String> eventImages = {
    'Temu Alumni': 'assets/images/temuAlumni.jpeg',
    'Hackathon': 'assets/images/hackathon.jpg',
    'StudyCom': 'assets/images/StudyCom.jpg',
    'Study Visit': 'assets/images/StudyVisit.jpg',
    'Workshop Ai': 'assets/images/workshop.jpg',
    'Regeneration': 'assets/images/regen.jpg',
  };

  void _fetchEvents() async {
    var eventQuery = FirebaseFirestore.instance.collection('events');

    try {
      // Fetch all events
      var event = await eventQuery.get();
      print("Fetched ${event.docs.length} events"); // Debugging line to check number of fetched documents

      // Separate events into upcoming, past and all events
      List<DocumentSnapshot> upcomingEvents = [];
      List<DocumentSnapshot> pastEvents = [];
      List<DocumentSnapshot> allEvents = [];

      for (var doc in event.docs) {
        var eventData = doc.data();

        // Check event status and categorize
        if (eventData['Status'] == 'upcoming') {
          upcomingEvents.add(doc);
        } else if (eventData['Status'] == 'past') {
          pastEvents.add(doc);
        }
        allEvents.add(doc); // Add to all events list
      }

      // Update the UI with the categorized events
      setState(() {
        _upcomingEvents = upcomingEvents;
        _pastEvents = pastEvents;
        _allEvents = allEvents;
      });
    } catch (e) {
      print("Error fetching events: $e"); // Catch any errors during fetch
    }
  }

  // Toggle between upcoming, past, and all events
  void _updateEventFilter(String status) {
    setState(() {
      _currentFilter = status;
    });
    _fetchEvents(); // Re-fetch events based on the new filter
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch events initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Page'),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateEventFilter,
            itemBuilder: (BuildContext context) {
              return {'All', 'Upcoming', 'Past'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _currentFilter == 'upcoming' ? 'Upcoming Events' 
              : _currentFilter == 'past' ? 'Past Events' 
              : 'All Events',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: [
                  _currentFilter == 'upcoming'
                    ? _buildEventList(_upcomingEvents)
                    : _currentFilter == 'past'
                      ? _buildEventList(_pastEvents)
                      : _buildEventList(_allEvents),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build event list
  Widget _buildEventList(List<DocumentSnapshot> eventList) {
    if (eventList.isEmpty) {
      return const Center(child: Text('No events available.'));
    }

    return Column(
      children: eventList.map((eventDoc) {
        var event = eventDoc.data() as Map<String, dynamic>;
        var eventTitle = event['title'] ?? 'No Title';
        var imageUrl = eventImages[eventTitle] ?? 'assets/images/default.jpg';

        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['description'] ?? 'No Description',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${event['location'] ?? 'No Location'}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ), 
                      const SizedBox(height: 8), 
                      Text(
                        'Contact Person: ${event['cp'] ?? 'No Cp'}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${event['date'] ?? 'No Date'}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Image.asset(
                  imageUrl,
                  width: 100, // Set the desired width
                  height: 100, // Set the desired height
                  fit: BoxFit.cover, // Adjust the fit if needed
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
