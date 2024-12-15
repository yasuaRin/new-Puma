import 'package:puma_is/services/event_services.dart';

class EventController {
  final EventServices _eventServices = EventServices();


  Future<void> addEvent({
    required String event_ID,
    required String title,
    required String description,
    required String location,
    required String status,
    required String date,
    required String cp,
  }) {
    return _eventServices.addEvent(
      event_ID: event_ID,
      title: title,
      description: description,
      location: location,
      status: status,
      date: date,
      cp: cp,
    );
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
    return _eventServices.updateEvent(
      event_ID: event_ID,
      title: title,
      description: description,
      location: location,
      status: status,
      date: date,
      cp: cp,
    );
  }


  Future<void> deleteEvent(String eventId) {
    return _eventServices.deleteEvent(eventId);
  }

  Future<List<Map<String, dynamic>>> fetchAllEvent() {
    return _eventServices.getAllEvent();
  }


  Future<List<Map<String, dynamic>>> fetchInfoForDate(DateTime selectedDate) {
    return _eventServices.getEventForDate(selectedDate);
  }


  Future<List<Map<String, dynamic>>> fetchEvent(String filter) {
    return _eventServices.getEventByFilter(filter);
  }
}