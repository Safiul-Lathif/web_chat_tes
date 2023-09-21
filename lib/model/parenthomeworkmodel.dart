

class HomeworkParent {
  HomeworkParent({
    required this.notificationId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectShortname,
    required this.staffName,
    required this.staffId,
    required this.classSection,
    required this.classConfig,
    required this.homeworkDate,
    required this.homeworkContent,
    required this.approvalStatus,
    required this.isPointed,
  });

  int notificationId;
  int subjectId;
  String subjectName;
  String subjectShortname;
  String staffName;
  int staffId;
  String classSection;
  int classConfig;
  String homeworkDate;
  String homeworkContent;
  int approvalStatus;
  int isPointed;

  factory HomeworkParent.fromJson(Map<String, dynamic> json) => HomeworkParent(
        notificationId: json["notification_id"],
        subjectId: json["subject_id"],
        subjectName: json["subject_name"],
        subjectShortname: json["subject_shortname"],
        staffName: json["staff_name"],
        staffId: json["staff_id"],
        classSection: json["class_section"],
        classConfig: json["class_config"],
        homeworkDate: json["homework_date"],
        homeworkContent: json["homework_content"],
        approvalStatus: json["approval_status"],
        isPointed: json["is_pointed"],
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "subject_id": subjectId,
        "subject_name": subjectName,
        "subject_shortname": subjectShortname,
        "staff_name": staffName,
        "staff_id": staffId,
        "class_section": classSection,
        "class_config": classConfig,
        "homework_date": homeworkDate,
        "homework_content": homeworkContent,
        "approval_status": approvalStatus,
        "is_pointed": isPointed,
      };
}
