class Candidate {
  String id;
  String chairpersonName;
  String chairpersonBatch;
  String viceName;
  String viceBatch;

  Candidate({
    required this.id,
    required this.chairpersonName,
    required this.chairpersonBatch,
    required this.viceName,
    required this.viceBatch,
  });

 
  factory Candidate.fromFirestore(Map<String, dynamic> doc, String id) {
    return Candidate(
      id: id,  
      chairpersonName: doc['chairperson_name'],
      chairpersonBatch: doc['chairperson_batch'],
      viceName: doc['vice_name'],
      viceBatch: doc['vice_batch'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chairperson_name': chairpersonName,
      'chairperson_batch': chairpersonBatch,
      'vice_name': viceName,
      'vice_batch': viceBatch,
    };
  }
}
