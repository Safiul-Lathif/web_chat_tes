class ClassGroup {
  ClassGroup({
    required this.schoolName,
    required this.userCategory,
    required this.classGroup,
  });

  String schoolName;
  String userCategory;
  List<ClassGroupElement> classGroup;

  factory ClassGroup.fromJson(Map<String, dynamic> json) => ClassGroup(
        schoolName: json["school_name"],
        userCategory: json["user_category"],
        classGroup: List<ClassGroupElement>.from(
            json["class_group"].map((x) => ClassGroupElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "school_name": schoolName,
        "user_category": userCategory,
        "class_group": List<dynamic>.from(classGroup.map((x) => x.toJson())),
      };
}

class ClassGroupElement {
  ClassGroupElement({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.classTeacher,
    required this.approvalPending,
    required this.parentOnline,
    required this.classConfig,
    required this.classteacher,
    required this.totalParentCount,
    required this.subjectList,
    required this.uploadedHomeworksCount,
  });

  int groupId;
  String groupName;
  String groupDescription;
  String classTeacher;
  int approvalPending;
  int parentOnline;
  int classConfig;
  Classteacher classteacher;
  int totalParentCount;
  List<SubjectList> subjectList;
  int uploadedHomeworksCount;

  factory ClassGroupElement.fromJson(Map<String, dynamic> json) =>
      ClassGroupElement(
        groupId: json["group_id"] ?? 0,
        groupName: json["group_name"] ?? '',
        groupDescription: json["group_description"] ?? '',
        classTeacher: json["class_teacher"] ?? '',
        approvalPending: json["approval_pending"] ?? 0,
        parentOnline: json["parent_online"] ?? 0,
        classConfig: json["class_config"] ?? 0,
        classteacher: classteacherValues.map[json["classteacher"]]!,
        totalParentCount: json["total_parent_count"] ?? 0,
        subjectList: List<SubjectList>.from(
            json["subject_list"].map((x) => SubjectList.fromJson(x))),
        uploadedHomeworksCount: json["uploaded_homeworks_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_name": groupName,
        "group_description": groupDescription,
        "class_teacher": classTeacher,
        "approval_pending": approvalPending,
        "parent_online": parentOnline,
        "class_config": classConfig,
        "classteacher": classteacherValues.reverse[classteacher],
        "total_parent_count": totalParentCount,
        "subject_list": List<dynamic>.from(subjectList.map((x) => x.toJson())),
        "uploaded_homeworks_count": uploadedHomeworksCount,
      };
}

enum Classteacher { YES }

final classteacherValues = EnumValues({"yes": Classteacher.YES});

class SubjectList {
  SubjectList({
    required this.id,
    required this.subjectName,
  });

  int id;
  String subjectName;

  factory SubjectList.fromJson(Map<String, dynamic> json) => SubjectList(
        id: json["id"],
        subjectName: json["subject_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subject_name": subjectName,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
