class EventModel {
  String eventID; // Manually defined event ID
  String name;
  String description;
  String location;
  String date;
  bool isUpcoming;

  EventModel({
    required this.eventID,
    required this.name,
    required this.description,
    required this.location,
    required this.date,
    required this.isUpcoming,
  });

  // Create an EventModel from a Map (Firestore Document)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventID: map['eventID'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      isUpcoming: map['isUpcoming'] ?? true,
    );
  }

  // Convert EventModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'eventID': eventID,
      'name': name,
      'description': description,
      'location': location,
      'date': date,
      'isUpcoming': isUpcoming,
    };
  }
}
