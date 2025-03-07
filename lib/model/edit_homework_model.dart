class EditHomeworkModel {
  EditHomeworkModel({
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
  List<Imageses> images;

  factory EditHomeworkModel.fromJson(Map<String, dynamic> json) =>
      EditHomeworkModel(
        notificationId: json["notification_id"] ?? 0,
        subjectId: json["subject_id"] ?? 0,
        subjectName: json["subject_name"] ?? '',
        subjectShortname: json["subject_shortname"] ?? '',
        staffName: json["staff_name"] ?? '',
        staffId: json["staff_id"] ?? 0,
        classteacherName: json["classteacher_name"] ?? '',
        classteacherId: json["classteacher_id"] ?? 0,
        classConfig: json["class_config"] ?? 0,
        classSection: json["class_section"] ?? '',
        homeworkDate:
            // DateTime.parse(json["homework_date"] != ""
            json["homework_date"] ?? '',
        //: DateTime.now()),
        percent: json["percent"] ?? 0,
        expiresIn: json["expires_in"] ?? '',
        completedCount: json["completed_count"] ?? 0,
        flag: json["flag"] ?? '',
        homeworkContent: json["homework_content"] ?? '',
        approvalStatus: json["approval_status"] ?? 0,
        isPointed: json["is_pointed"] ?? 0,
        images: List<Imageses>.from(
            json["images"].map((x) => Imageses.fromJson(x))),
      );
}

class Imageses {
  Imageses({
    required this.image,
    required this.id,
  });

  String image;
  int id;

  factory Imageses.fromJson(Map<String, dynamic> json) => Imageses(
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
      };
}
