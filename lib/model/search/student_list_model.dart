class StudentList {
  int id;
  String userId;
  String firstName;
  dynamic lastName;
  String admissionNumber;
  String dob;
  int rollNumber;
  int gender;
  String profileImage;
  int classConfig;
  int userStatus;
  int createdBy;
  dynamic updatedBy;
  DateTime createdTime;
  DateTime updatedTime;
  String guardianName;
  String motherName;
  String fatherName;
  int guardianMobile;
  int motherMobile;
  int fatherMobile;
  String studentName;
  String studentListClass;
  String classTeacher;
  String studentProfileImage;

  StudentList({
    required this.id,
    required this.userId,
    required this.firstName,
    this.lastName,
    required this.admissionNumber,
    required this.dob,
    required this.rollNumber,
    required this.gender,
    required this.profileImage,
    required this.classConfig,
    required this.userStatus,
    required this.createdBy,
    this.updatedBy,
    required this.createdTime,
    required this.updatedTime,
    required this.guardianName,
    required this.motherName,
    required this.fatherName,
    required this.guardianMobile,
    required this.motherMobile,
    required this.fatherMobile,
    required this.studentName,
    required this.studentListClass,
    required this.classTeacher,
    required this.studentProfileImage,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        admissionNumber: json["admission_number"] ?? '',
        dob: json["dob"] ?? '',
        rollNumber: json["roll_number"] ?? 0,
        gender: json["gender"] ?? 0,
        profileImage: json["profile_image"] ?? '',
        classConfig: json["class_config"] ?? 0,
        userStatus: json["user_status"] ?? 0,
        createdBy: json["created_by"] ?? 0,
        updatedBy: json["updated_by"] ?? '',
        createdTime: DateTime.parse(json["created_time"] ?? ''),
        updatedTime: DateTime.parse(json["updated_time"] ?? ''),
        guardianName: json["guardian_name"] ?? '',
        motherName: json["mother_name"] ?? '',
        fatherName: json["father_name"] ?? '',
        guardianMobile: json["guardian_mobile"] ?? 0,
        motherMobile: json["mother_mobile"] ?? 0,
        fatherMobile: json["father_mobile"] ?? 0,
        studentName: json["student_name"] ?? '',
        studentListClass: json["class"] ?? '',
        classTeacher: json["class_teacher"] ?? '',
        studentProfileImage: json["student_profile_image"] ?? '',
      );
}

class StudentInfo {
  int studentId;
  String studentName;
  int fatherMobileNumber;
  dynamic fatherEmailAddress;
  String fatherName;
  int fatherId;
  int motherMobileNumber;
  String motherEmailAddress;
  String motherName;
  int motherId;
  int guardianMobileNumber;
  String guardianEmailAddress;
  String guardianName;
  int guardianId;
  String admissionNumber;
  int rollNo;
  int dob;
  int doj;
  String employeeNo;
  String gender;
  String photo;
  String temporaryStudent;
  int classSection;

  StudentInfo({
    required this.studentId,
    required this.studentName,
    required this.fatherMobileNumber,
    this.fatherEmailAddress,
    required this.fatherName,
    required this.fatherId,
    required this.motherMobileNumber,
    required this.motherEmailAddress,
    required this.motherName,
    required this.motherId,
    required this.guardianMobileNumber,
    required this.guardianEmailAddress,
    required this.guardianName,
    required this.guardianId,
    required this.admissionNumber,
    required this.rollNo,
    required this.dob,
    required this.doj,
    required this.employeeNo,
    required this.gender,
    required this.photo,
    required this.temporaryStudent,
    required this.classSection,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) => StudentInfo(
        studentId: json["student_id"],
        studentName: json["student_name"],
        fatherMobileNumber: json["father_mobile_number"],
        fatherEmailAddress: json["father_email_address"],
        fatherName: json["father_name"],
        fatherId: json["father_id"],
        motherMobileNumber: json["mother_mobile_number"],
        motherEmailAddress: json["mother_email_address"],
        motherName: json["mother_name"],
        motherId: json["mother_id"],
        guardianMobileNumber: json["guardian_mobile_number"],
        guardianEmailAddress: json["guardian_email_address"],
        guardianName: json["guardian_name"],
        guardianId: json["guardian_id"],
        admissionNumber: json["admission_number"],
        rollNo: json["roll_no"],
        dob: json["dob"],
        doj: json["doj"],
        employeeNo: json["employee_no"],
        gender: json["gender"],
        photo: json["photo"],
        temporaryStudent: json["temporary_student"],
        classSection: json["class_section"],
      );
}
