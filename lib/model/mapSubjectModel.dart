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
        id: json["id"],
        subjectName: json["subject_name"],
        isSelected: false
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
      };
}
