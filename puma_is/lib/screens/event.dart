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
      var event = await eventQuery.get();
      print("Fetched ${event.docs.length} events");

      List<DocumentSnapshot> upcomingEvents = [];
      List<DocumentSnapshot> pastEvents = [];
      List<DocumentSnapshot> allEvents = [];

      for (var doc in event.docs) {
        var eventData = doc.data() as Map<String, dynamic>;

        if (eventData['Status'] == 'upcoming') {
          upcomingEvents.add(doc);
        } else if (eventData['Status'] == 'past') {
          pastEvents.add(doc);
        }
        allEvents.add(doc);
      }

      setState(() {
        _upcomingEvents = upcomingEvents;
        _pastEvents = pastEvents;
        _allEvents = allEvents;
      });
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void _updateEventFilter(String status) {
    setState(() {
      _currentFilter = status;
    });
    _fetchEvents();
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateEventFilter,
            itemBuilder: (BuildContext context) {
              return {'All', 'Upcoming', 'Past'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Center(
                    child: Text(
                      choice,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75, // Adjust the aspect ratio as needed
                ),
                itemCount: _currentFilter == 'upcoming'
                    ? _upcomingEvents.length
                    : _currentFilter == 'past'
                        ? _pastEvents.length
                        : _allEvents.length,
                itemBuilder: (context, index) {
                  var event = _currentFilter == 'upcoming'
                      ? _upcomingEvents[index]
                      : _currentFilter == 'past'
                          ? _pastEvents[index]
                          : _allEvents[index];
                  return _buildEventCard(event, isDarkMode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(DocumentSnapshot eventDoc, bool isDarkMode) {
    var event = eventDoc.data() as Map<String, dynamic>;
    var eventTitle = event['title'] ?? 'No Title';
    var imageUrl = eventImages[eventTitle] ?? 'assets/images/default.jpg';

    String status = event['Status'] ?? 'upcoming';
    Color statusColor = status == 'upcoming' ? Colors.green : Colors.red;

    return Card(
      color: isDarkMode ? const Color.fromARGB(255, 64, 64, 64) : Colors.white, // Change color based on dark mode
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: statusColor,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Text(
              status == 'upcoming' ? 'Upcoming' : 'Past',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event['description'] ?? 'No Description',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: isDarkMode ? Colors.white : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      'Location: ${event['location'] ?? 'No Location'}',
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.contact_phone, size: 16, color: isDarkMode ? Colors.white : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      'Contact Person: ${event['cp'] ?? 'No CP'}',
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.date_range, size: 16, color: isDarkMode ? Colors.white : Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      'Date: ${event['date'] ?? 'No Date'}',
                      style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
