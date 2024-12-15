class MemberModel {
  final String memberId;
  final String fullName;
  final int batch;
  final String position;
  final String division;

  MemberModel({
    required this.memberId,
    required this.fullName,
    required this.batch,
    required this.position,
    required this.division
  });

  factory MemberModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MemberModel(
      memberId: documentId,
      fullName: map['fullName'] ?? '',
      batch: map['batch'] ?? '',
      position: map['position'] ?? '',
      division: map['division'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'batch': batch,
      'position': position,
      'division': division,
    };
  }
}
