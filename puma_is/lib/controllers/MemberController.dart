import 'package:puma_is/services/member_service.dart';

class MemberController {
  final MemberService _memberServices = MemberService();

  // Add a new member
  Future<void> addMember({
    required String fullName,
    required int batch,
    required String position,
  }) {
    return _memberServices.addMember(
      fullName: fullName,
      batch: batch,
      position: position,
    );
  }

  // Update an existing member
  Future<void> updateMember({
    required String memberId,
    required String fullName,
    required int batch,
    required String position,
  }) {
    return _memberServices.updateMember(
      memberId: memberId,
      fullName: fullName,
      batch: batch,
      position: position,
    );
  }

  // Delete a member
  Future<void> deleteMember(String memberId) {
    return _memberServices.deleteMember(memberId);
  }

  // Fetch all members
  Future<List<Map<String, dynamic>>> fetchAllMembers() {
    return _memberServices.getAllMembers();
  }

  // Fetch members by batch
  Future<List<Map<String, dynamic>>> fetchMembersByBatch(int batch) {
    return _memberServices.getMembersByBatch(batch);
  }
}
