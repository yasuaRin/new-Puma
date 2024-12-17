import 'package:cloud_firestore/cloud_firestore.dart';

class MemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('Members');

  Future<void> addMember({
    required String fullName,
    required int batch, 
    required String position,
    required String division,
  }) {
    return _memberCollection.add({
      'fullName': fullName,
      'batch': batch,
      'position': position,
      'division': division,
    });
  }

  Future<void> updateMember({
    required String memberId, 
    required String fullName,
    required int batch,
    required String position,
    required String division,
  }) {
    return _memberCollection.doc(memberId).update({
      'fullName': fullName,
      'batch': batch,
      'position': position,
      'division': division,
    });
  }

  Future<void> deleteMember(String memberId) {
    return _memberCollection.doc(memberId).delete();
  }

  Future<List<Map<String, dynamic>>> getAllMembers() async {
    QuerySnapshot snapshot = await _memberCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

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
   Future<List<Map<String, dynamic>>> getMembersByDivision(String division) async {
    QuerySnapshot snapshot = await _memberCollection
        .where('division', isEqualTo: division)
        .get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }
}