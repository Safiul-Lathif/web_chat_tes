class SubjectList {
  SubjectList({
    required this.id,
    required this.subjectName,
    required this.isSelected,
  });

  int id;
  String subjectName;
  bool isSelected;

  factory SubjectList.fromJson(Map<String, dynamic> json) => SubjectList(
      id: json["id"], subjectName: json["subject_name"], isSelected: false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
      };
}

class SectionDetail {
  SectionDetail({
    required this.classSection,
    required this.id,
  });

  String classSection;
  int id;

  factory SectionDetail.fromJson(Map<String, dynamic> json) => SectionDetail(
        classSection: json["class_section"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "class_section": classSection,
        "id": id,
      };
}
