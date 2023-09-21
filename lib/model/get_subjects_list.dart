class GetSubjectList {
  GetSubjectList({
    required this.subjects,
  });

  List<Subjects> subjects;

  factory GetSubjectList.fromJson(Map<String, dynamic> json) => GetSubjectList(
        subjects: List<Subjects>.from(
            json["subjects"].map((x) => Subjects.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}

class Subjects {
  Subjects({
    required this.id,
    required this.subjectName,
  });

  int id;
  String subjectName;

  factory Subjects.fromJson(Map<String, dynamic> json) => Subjects(
        id: json["id"],
        subjectName: json["subject_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
      };
}
