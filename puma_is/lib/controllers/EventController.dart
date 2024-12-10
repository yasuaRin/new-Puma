import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puma_is/services/event_services.dart';
import 'package:puma_is/models/event_model.dart';

class EventController {
  final EventService _eventService = EventService();

  // Create Event
  Future<void> createEvent(EventModel event) async {
    try {
      await _eventService.createEvent(event);
    } catch (e) {
      print("Error creating event: $e");
    }
  }

  // Update Event
  Future<void> updateEvent(EventModel event, String documentId) async {
    try {
      await _eventService.updateEvent(event, documentId);
    } catch (e) {
      print("Error updating event: $e");
    }
  }

  // Fetch Events
  Stream<List<EventModel>> getEvents() {
    return _eventService.getEvents();
  }
}
