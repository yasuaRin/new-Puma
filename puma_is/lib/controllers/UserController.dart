import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  Future<void> createUser({
    required String ID,
    required String email,
    required String fullName,
    required String password,
    required bool termsCondition,
  }) async {
    await _firebaseFirestore.collection('user').add({
      'ID': ID,
      'email': email,
      'fullName': fullName,
      'password': password,
      'termsCondition': termsCondition,
    });
  }


  Future<void> updateUser({
    required String userId,
    required String ID,
    required String email,
    required String fullName,
    required String password,
    required bool termsCondition,
  }) async {
    await _firebaseFirestore.collection('user').doc(userId).update({
      'ID': ID,
      'email': email,
      'fullName': fullName,
      'password': password,
      'termsCondition': termsCondition,
    });
  }


  Future<void> deleteUser(String userId) async {
    await _firebaseFirestore.collection('user').doc(userId).delete();
  }
}
