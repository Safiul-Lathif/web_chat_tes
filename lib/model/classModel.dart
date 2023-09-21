// ignore_for_file: file_names
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
  ClassGroupElement(
      {required this.groupId,
      required this.groupName,
      this.groupDescription,
      required this.classTeacher,
      required this.approvalPending,
      required this.parentOnline,
      required this.classConfig,
      required this.classteacher,
      required this.allUserCount});

  int groupId;
  String groupName;
  dynamic groupDescription;
  String classTeacher;
  int approvalPending;
  int parentOnline;
  int classConfig;
  String classteacher;
  int allUserCount;

  factory ClassGroupElement.fromJson(Map<String, dynamic> json) =>
      ClassGroupElement(
          groupId: json["group_id"] ?? 0,
          groupName: json["group_name"] ?? '',
          groupDescription: json["group_description"] ?? '',
          classTeacher: json["class_teacher"] ?? '',
          approvalPending: json["approval_pending"] ?? 0,
          parentOnline: json["parent_online"] ?? 0,
          classConfig: json["class_config"] ?? 0,
          classteacher: json["classteacher"] ?? '',
          allUserCount: json["all_user_count"] ?? 0);

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_name": groupName,
        "group_description": groupDescription,
        "class_teacher": classTeacher,
        "approval_pending": approvalPending,
        "parent_online": parentOnline,
        "class_config": classConfig,
        "classteacher": classteacher,
        "all_user_count": allUserCount
      };
}
