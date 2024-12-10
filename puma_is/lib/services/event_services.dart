import 'package:cloud_firestore/cloud_firestore.dart';

class EventServices {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('events');

  // Add new event
  Future<void> addEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required DateTime dateTime,
  }) {
    return _eventCollection.add({
      'event_ID': event_ID,
      'title': title,
      'description': description,
      'location': location,
      'Status': status,
      'dateTime': dateTime,
    });
  }

  // Update event
  Future<void> updateEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required DateTime dateTime,
  }) {
    return _eventCollection.doc(event_ID).update({
      'event_ID': event_ID,
      'title': title,
      'description': description,
      'location': location,
      'Status': status,
      'dateTime': dateTime,
    });
  }

  // Delete event
  Future<void> deleteEvent(String event_ID) {
    return _eventCollection.doc(event_ID).delete();
  }

  // Fetch all events
  Future<List<Map<String, dynamic>>> getAllEvent() async {
    QuerySnapshot snapshot = await _eventCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Fetch events for a specific date
  Future<List<Map<String, dynamic>>> getEventForDate(DateTime selectedDate) async {
    QuerySnapshot snapshot = await _eventCollection
        .where('dateTime', isEqualTo: selectedDate)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Fetch events by a specific filter
  Future<List<Map<String, dynamic>>> getEventByFilter(String filter) async {
    QuerySnapshot snapshot = await _eventCollection
        .where('Status', isEqualTo: filter) // Replace 'status' with your filter field
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}
