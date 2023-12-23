import 'package:file_picker/file_picker.dart';

class StaffHomework {
  StaffHomework(
      {required this.notificationId,
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
      required this.notCompletedStudents,
      required this.flag,
      required this.homeworkContent,
      required this.approvalStatus,
      required this.isPointed,
      required this.images,
      required this.attachments,
      required this.profileImage,
      required this.edited});

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
  int notCompletedStudents;
  String flag;
  String homeworkContent;
  int approvalStatus;
  int isPointed;
  int edited;
  String profileImage;
  List<dynamic> images;
  List<PlatformFile> attachments;

  factory StaffHomework.fromJson(Map<String, dynamic> json) => StaffHomework(
        notificationId: json["notification_id"] ?? 0,
        subjectId: json["subject_id"] ?? 0,
        subjectName: json["subject_name"] ?? '',
        subjectShortname: json["subject_shortname"] ?? '',
        staffName: json["staff_name"] ?? "",
        staffId: json["staff_id"] ?? 0,
        classteacherName: json["classteacher_name"] ?? '',
        classteacherId: json["classteacher_id"] ?? 0,
        classConfig: json["class_config"] ?? 0,
        classSection: json["class_section"] ?? '',
        homeworkDate: json["homework_date"] ?? '',
        percent: json["percent"] ?? 0,
        expiresIn: json["expires_in"] ?? '',
        completedCount: json["completed_count"] ?? 0,
        notCompletedStudents: json["not_completed_students"] ?? 0,
        flag: json["flag"] ?? '',
        homeworkContent: json["homework_content"] ?? '',
        edited: json['edited'] ?? 0,
        approvalStatus: json["approval_status"] ?? 0,
        profileImage: json['profile_image'] ?? '',
        isPointed: json["is_pointed"] ?? 0,
        images: List<dynamic>.from(json["images"].map((x) => x)),
        attachments: [],
      );
}
