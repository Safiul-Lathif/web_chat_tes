class Verifysubjecteslist {
  Verifysubjecteslist({
    required this.classSectionId,
    required this.classSectionName,
    this.divisionId,
    required this.subjects,
  });

  int classSectionId;
  String classSectionName;
  dynamic divisionId;
  List<Subject> subjects;

  factory Verifysubjecteslist.fromJson(Map<String, dynamic> json) =>
      Verifysubjecteslist(
        classSectionId: json["class_section_id"],
        classSectionName: json["class_section_name"],
        divisionId: json["division_id"],
        subjects: List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "class_section_id": classSectionId,
        "class_section_name": classSectionName,
        "division_id": divisionId,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}

class Subject {
  Subject({
    required this.subjectId,
    required this.subjectName,
  });

  int subjectId;
  String subjectName;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        subjectId: json["subject_id"] ?? 0,
        subjectName: json["subject_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "subject_id": subjectId,
        "subject_name": subjectName,
      };
}
