class HomeworkStatusModel {
  int id;
  int studentId;
  int parentId;
  int status;
  int reason;
  DateTime reportedTime;
  String studentName;
  String parentName;

  HomeworkStatusModel({
    required this.id,
    required this.studentId,
    required this.parentId,
    required this.status,
    required this.reason,
    required this.reportedTime,
    required this.studentName,
    required this.parentName,
  });

  factory HomeworkStatusModel.fromJson(Map<String, dynamic> json) =>
      HomeworkStatusModel(
        id: json["id"],
        studentId: json["student_id"],
        parentId: json["parent_id"],
        status: json["status"],
        reason: json["reason"],
        reportedTime: DateTime.parse(json["reported_time"]),
        studentName: json["student_name"],
        parentName: json["parent_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "parent_id": parentId,
        "status": status,
        "reason": reason,
        "reported_time": reportedTime.toIso8601String(),
        "student_name": studentName,
        "parent_name": parentName,
      };
}
