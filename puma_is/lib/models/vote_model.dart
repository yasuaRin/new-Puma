import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore package

class Vote {
  final String candidate;
  final String email;
  final DateTime timestamp;

  Vote({
    required this.candidate,
    required this.email,
    required this.timestamp,
  });

  // Generate a unique ID using the current timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();  // Use timestamp as ID
  }

  // Convert the Vote object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'candidate': candidate,
      'email': email,
      'timestamp': Timestamp.fromDate(timestamp), // Convert DateTime to Firestore Timestamp
    };
  }

  // Create a Vote object from a Map (for Firestore retrieval)
  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      candidate: map['candidate'],
      email: map['email'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),  // Convert Firestore Timestamp to DateTime
    );
  }
}
