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

  // Factory constructor to create an instance from a map
  factory MemberModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MemberModel(
      memberId: documentId,
      fullName: map['fullName'] ?? '',
      batch: map['batch'] ?? '',
      position: map['position'] ?? '',
      division: map['division'] ?? '',
    );
  }

  // Convert an instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'batch': batch,
      'position': position,
      'division': division,
    };
  }
}
