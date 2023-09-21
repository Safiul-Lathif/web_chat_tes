class SchoolAttendanceListModel {
  int leftStudents;
  Attendance schoolAttendance;
  List<Attendance> attendance;

  SchoolAttendanceListModel({
    required this.leftStudents,
    required this.schoolAttendance,
    required this.attendance,
  });

  factory SchoolAttendanceListModel.fromJson(Map<String, dynamic> json) =>
      SchoolAttendanceListModel(
        leftStudents: json["left_students"],
        schoolAttendance: Attendance.fromJson(json["school_attendance"]),
        attendance: List<Attendance>.from(
            json["attendance"].map((x) => Attendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "left_students": leftStudents,
        "school_attendance": schoolAttendance.toJson(),
        "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
      };
}

class Attendance {
  String? classSectionName;
  int presentTotal;
  int absentTotal;
  int leaveTotal;
  int presentPercentage;
  int absentPercentage;
  // double leavePercentage;
  int? studentsCount;
  int classConfigId;

  Attendance({
    this.classSectionName,
    required this.presentTotal,
    required this.absentTotal,
    required this.leaveTotal,
    required this.presentPercentage,
    required this.absentPercentage,
    // required this.leavePercentage,
    required this.classConfigId,
    this.studentsCount,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        classSectionName: json["class_section_name"],
        presentTotal: json["present_total"] ?? 0,
        absentTotal: json["absent_total"] ?? 0,
        leaveTotal: json["leave_total"] ?? 0,
        presentPercentage: json["present_percentage"] ?? 0,
        absentPercentage: json["absent_percentage"] ?? 0,
        // leavePercentage:
        //     json["leave_percentage"] ?? 0,
        classConfigId: json['config_id'] ?? 0,
        studentsCount: json["students_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "class_section_name": classSectionName,
        "present_total": presentTotal,
        "absent_total": absentTotal,
        "leave_total": leaveTotal,
        "present_percentage": presentPercentage,
        "absent_percentage": absentPercentage,
        // "leave_percentage": leavePercentage,
        "students_count": studentsCount,
        "config_id": classConfigId
      };
}

class AttendanceSubmitList {
  final String studentId;
  final String attendanceStatus;
  final String studentName;

  AttendanceSubmitList(
      {required this.studentId,
      required this.attendanceStatus,
      required this.studentName});
}
