
class EventModel {
  final String eventID;
  final String title;
  final String description;
  final String location;
  final String status;
  final DateTime date;
  final String cp;

  EventModel({
    required this.eventID,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.date, 
    required this.cp, 
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventID: map['event_ID'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? '',
      date: DateTime.parse(map['date']),
      cp: map['cp'] ?? '',
    );
  }
}
