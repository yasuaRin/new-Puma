import 'package:puma_is/services/member_service.dart';

class MemberController {
  final MemberService _memberServices = MemberService();

  
  Future<void> addMember({
    required String fullName,
    required int batch,
    required String position,
    required String division,
  }) {
    return _memberServices.addMember(
      fullName: fullName,
      batch: batch,
      position: position,
      division: division,
    );
  }

  Future<void> updateMember({
    required String memberId,
    required String fullName,
    required int batch,
    required String position,
    required String division,
  }) {
    return _memberServices.updateMember(
      memberId: memberId,
      fullName: fullName,
      batch: batch,
      position: position,
      division: division,
    );
  }


  Future<void> deleteMember(String memberId) {
    return _memberServices.deleteMember(memberId);
  }

 
  Future<List<Map<String, dynamic>>> fetchAllMembers() {
    return _memberServices.getAllMembers();
  }


  Future<List<Map<String, dynamic>>> fetchMembersByBatch(int batch) {
    return _memberServices.getMembersByBatch(batch);
  }
  Future<List<Map<String, dynamic>>> fetchMembersByDivision(String division) {
    return _memberServices.getMembersByDivision(division);
  }
}
