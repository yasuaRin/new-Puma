import 'package:puma_is/services/event_services.dart';

class EventController {
  final EventServices _eventServices = EventServices();

  // Add a new event
  Future<void> addEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required DateTime dateTime,
  }) {
    return _eventServices.addEvent(
      event_ID: event_ID,
      title: title,
      description: description,
      location: location,
      status: status,
      dateTime: dateTime,
    );
  }

  // Update an existing event
  Future<void> updateEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required DateTime dateTime,
  }) {
    return _eventServices.updateEvent(
      event_ID: event_ID,
      title: title,
      description: description,
      location: location,
      status: status,
      dateTime: dateTime,
    );
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) {
    return _eventServices.deleteEvent(eventId);
  }

  // Fetch all events
  Future<List<Map<String, dynamic>>> fetchAllEvent() {
    return _eventServices.getAllEvent();
  }

  // Fetch events for a specific date
  Future<List<Map<String, dynamic>>> fetchInfoForDate(DateTime selectedDate) {
    return _eventServices.getEventForDate(selectedDate);
  }

  // Fetch events by filter (e.g., status, location, etc.)
  Future<List<Map<String, dynamic>>> fetchEvent(String filter) {
    return _eventServices.getEventByFilter(filter);
  }
}
