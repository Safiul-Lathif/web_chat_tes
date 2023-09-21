import 'package:file_picker/file_picker.dart';

class StaffHomework {
  StaffHomework({
    required this.notificationId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectShortname,
    required this.staffName,
    required this.staffId,
    required this.classteacherName,
    required this.classteacherId,
    required this.classConfig,
    required this.classSection,
    required this.homeworkDate,
    required this.percent,
    required this.expiresIn,
    required this.completedCount,
    required this.flag,
    required this.homeworkContent,
    required this.approvalStatus,
    required this.isPointed,
    required this.images,
  });

  int notificationId;
  int subjectId;
  String subjectName;
  String subjectShortname;
  String staffName;
  int staffId;
  String classteacherName;
  int classteacherId;
  int classConfig;
  String classSection;
  String homeworkDate;
  int percent;
  String expiresIn;
  int completedCount;
  String flag;
  String homeworkContent;
  int approvalStatus;
  int isPointed;
  List<dynamic> images;

  factory StaffHomework.fromJson(Map<String, dynamic> json) => StaffHomework(
        notificationId: json["notification_id"],
        subjectId: json["subject_id"],
        subjectName: json["subject_name"],
        subjectShortname: json["subject_shortname"],
        staffName: json["staff_name"],
        staffId: json["staff_id"],
        classteacherName: json["classteacher_name"],
        classteacherId: json["classteacher_id"],
        classConfig: json["class_config"],
        classSection: json["class_section"],
        homeworkDate: json["homework_date"],
        percent: json["percent"],
        expiresIn: json["expires_in"],
        completedCount: json["completed_count"],
        flag: json["flag"],
        homeworkContent: json["homework_content"],
        approvalStatus: json["approval_status"],
        isPointed: json["is_pointed"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "subject_id": subjectId,
        "subject_name": subjectName,
        "subject_shortname": subjectShortname,
        "staff_name": staffName,
        "staff_id": staffId,
        "classteacher_name": classteacherName,
        "classteacher_id": classteacherId,
        "class_config": classConfig,
        "class_section": classSection,
        "homework_date": homeworkDate,
        "percent": percent,
        "expires_in": expiresIn,
        "completed_count": completedCount,
        "flag": flag,
        "homework_content": homeworkContent,
        "approval_status": approvalStatus,
        "is_pointed": isPointed,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
