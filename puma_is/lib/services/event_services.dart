import 'package:cloud_firestore/cloud_firestore.dart';

class EventServices {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> addEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required String date,
    required String cp,
  }) {
    return _eventCollection.add({
      'event_ID': event_ID,
      'title': title,
      'description': description,
      'location': location,
      'Status': status,
      'date': date,
      'cp': cp,
    });
  }

  Future<void> updateEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required String date,
    required String cp,
  }) {
    return _eventCollection.doc(event_ID).update({
      'event_ID': event_ID,
      'title': title,
      'description': description,
      'location': location,
      'Status': status,
      'date': date,
      'cp': cp,
    });
  }

  Future<void> deleteEvent(String eventId) {
    return _eventCollection.doc(eventId).delete();
  }

  Future<List<Map<String, dynamic>>> getAllEvent() async {
    QuerySnapshot snapshot = await _eventCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

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

  Future<List<Map<String, dynamic>>> getEventByFilter(String filter) async {
    QuerySnapshot snapshot = await _eventCollection
        .where('Status', isEqualTo: filter) 
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}