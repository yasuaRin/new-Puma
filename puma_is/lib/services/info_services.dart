import 'package:cloud_firestore/cloud_firestore.dart';

class InfoServices {
  final CollectionReference _infoCollection =
      FirebaseFirestore.instance.collection('info');

  // Add new info
  Future<void> addInfo({
    required String title,
    required String content,
    required DateTime dateTime,
    required String contactPerson,
  }) {
    return _infoCollection.add({
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'contactPerson': contactPerson,
    });
  }

  // Update info
  Future<void> updateInfo({
    required String infoId,
    required String title,
    required String content,
    required DateTime dateTime,
    required String contactPerson,
  }) {
    return _infoCollection.doc(infoId).update({
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'contactPerson': contactPerson,
    });
  }

  // Delete info
  Future<void> deleteInfo(String infoId) {
    return _infoCollection.doc(infoId).delete();
  }

  // Fetch all info
  Future<List<Map<String, dynamic>>> getAllInfo() async {
    QuerySnapshot snapshot = await _infoCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Fetch info for a specific date
  Future<List<Map<String, dynamic>>> getInfoForDate(DateTime selectedDate) async {
    QuerySnapshot snapshot = await _infoCollection
        .where('dateTime', isEqualTo: selectedDate)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}
