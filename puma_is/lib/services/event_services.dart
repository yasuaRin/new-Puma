import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:puma_is/models/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create Event in Firestore
  Future<void> createEvent(EventModel event) async {
    try {
      // Firestore auto-generates document ID for new event
      DocumentReference docRef = await _db.collection('events').add(event.toMap());

      // Update the document with the manually added eventID field
      await docRef.update({'eventID': event.eventID});
      print("Event created with ID: ${docRef.id}");
    } catch (e) {
      print("Error creating event in Firestore: $e");
    }
  }

  // Update Event in Firestore
  Future<void> updateEvent(EventModel event, String documentId) async {
    try {
      await _db.collection('events').doc(documentId).update(event.toMap());
      print("Event updated successfully.");
    } catch (e) {
      print("Error updating event in Firestore: $e");
    }
  }

  // Fetch Events from Firestore
  Stream<List<EventModel>> getEvents() {
    try {
      return _db.collection('events').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return EventModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error fetching events from Firestore: $e");
      return Stream.empty();
    }
  }
}
