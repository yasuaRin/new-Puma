import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class EventModel {
  final String event_ID;
  final String title;
  final String description;
  final String location;
  final String status;
  final DateTime timestamp;

  EventModel({
    required this.event_ID,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.timestamp,
  });

  // Generate a unique ID using the current timestamp
  static String generateId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Use timestamp as ID
  }

  // Convert the Vote object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'event_ID': event_ID,
      'title': title,
      'description': description,
      'location': location,
      'Status': status,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create a event object from a Map (for Firestore retrieval)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      event_ID: map['event_ID'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      status: map['Status'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
