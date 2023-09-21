class StudentsAttendanceModel {
  String firstName;
  int id;
  int classConfig;
  String admissionNumber;
  int rollNumber;
  String profileImage;
  String classSectionName;
  String fatherName;
  String motherName;
  String guardianName;
  int fatherMobileNo;
  int motherMobileNo;
  int guardianMobileNo;
  int presentTotal;
  int absentTotal;
  int leaveTotal;
  int presentPercentage;
  int absentPercentage;
  int leavePercentage;
  int sessionType;
  DateTime attendanceDate;
  dynamic reason;
  int attendanceStatus;
  int totalDays;

  StudentsAttendanceModel(
      {required this.firstName,
      required this.id,
      required this.classConfig,
      required this.admissionNumber,
      required this.rollNumber,
      required this.profileImage,
      required this.classSectionName,
      required this.fatherName,
      required this.motherName,
      required this.guardianName,
      required this.fatherMobileNo,
      required this.motherMobileNo,
      required this.guardianMobileNo,
      required this.presentTotal,
      required this.absentTotal,
      required this.leaveTotal,
      required this.presentPercentage,
      required this.absentPercentage,
      required this.leavePercentage,
      required this.sessionType,
      required this.attendanceDate,
      required this.reason,
      required this.attendanceStatus,
      required this.totalDays});

  factory StudentsAttendanceModel.fromJson(Map<String, dynamic> json) =>
      StudentsAttendanceModel(
          firstName: json["first_name"] ?? '',
          id: json["id"] ?? 0,
          classConfig: json["class_config"] ?? 0,
          admissionNumber: json["admission_number"] ?? '',
          rollNumber: json["roll_number"] ?? 0,
          profileImage: json["profile_image"] ?? '',
          classSectionName: json["class_section_name"] ?? '',
          fatherName: json["father_name"] ?? '',
          motherName: json["mother_name"] ?? '',
          guardianName: json["guardian_name"] ?? '',
          fatherMobileNo: json["father_mobile_no"] ?? 0,
          motherMobileNo: json["mother_mobile_no"] ?? 0,
          guardianMobileNo: json["guardian_mobile_no"] ?? 0,
          presentTotal: json["present_total"] ?? 0,
          absentTotal: json["absent_total"] ?? 0,
          leaveTotal: json["leave_total"] ?? 0,
          presentPercentage: json["present_percentage"] ?? 0,
          absentPercentage: json["absent_percentage"] ?? 0,
          leavePercentage: json["leave_percentage"] ?? 0,
          sessionType: json["session_type"] ?? 0,
          attendanceDate: DateTime.parse(json["attendance_date"]),
          reason: json["reason"] ?? '',
          attendanceStatus: json["attendance_status"] ?? 0,
          totalDays: json['total_days'] ?? 0);
}
