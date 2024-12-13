import 'package:cloud_firestore/cloud_firestore.dart';

class MemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('Members');

  // Add new member
  Future<void> addMember({
    required String fullName,
    required int batch, // Changed Bool to bool (Dart type)
    required String position,
  }) {
    return _memberCollection.add({
      'fullName': fullName,
      'batch': batch,
      'position': position,
    });
  }

  // Update member
  Future<void> updateMember({
    required String memberId, // Added memberId to specify which member to update
    required String fullName,
    required int batch,
    required String position,
  }) {
    return _memberCollection.doc(memberId).update({
      'fullName': fullName,
      'batch': batch,
      'position': position,
    });
  }

  // Delete member
  Future<void> deleteMember(String memberId) {
    return _memberCollection.doc(memberId).delete();
  }

  // Fetch all members
  Future<List<Map<String, dynamic>>> getAllMembers() async {
    QuerySnapshot snapshot = await _memberCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Fetch members by batch (corrected date-based logic to batch-based logic)
  Future<List<Map<String, dynamic>>> getMembersByBatch(int batch) async {
    QuerySnapshot snapshot = await _memberCollection
        .where('batch', isEqualTo: batch)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}
