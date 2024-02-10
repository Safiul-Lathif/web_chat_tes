// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FetchStaffList {
  FetchStaffList(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.mobileNumber,
      required this.profileImage,
      required this.specializedIn,
      required this.userCategory,
      required this.emailId,
      required this.classTeacher,
      required this.classConfig,
      required this.dob,
      required this.doj,
      required this.employeeNumber,
      required this.subjectTeacher});

  int id;
  String userId;
  String firstName;
  int mobileNumber;
  String profileImage;
  int specializedIn;
  int userCategory;
  String emailId;
  String classTeacher;
  int classConfig;
  String employeeNumber;
  dynamic dob;
  dynamic doj;
  List<SubjectTeacher> subjectTeacher;

  factory FetchStaffList.fromJson(Map<String, dynamic> json) => FetchStaffList(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? '',
      firstName: json["first_name"] ?? '',
      mobileNumber: json["mobile_number"] ?? 0,
      profileImage: json["profile_image"] ?? '',
      specializedIn: json["specialized_in"] ?? 0,
      userCategory: json["user_category"] ?? 0,
      emailId: json["email_id"] ?? '',
      classTeacher: json["class_teacher"] ?? 'no',
      classConfig: json["class_config"] ?? 0,
      dob: json["dob"] ?? '',
      doj: json["doj"] ?? '',
      subjectTeacher: List<SubjectTeacher>.from(
          json["subject_teacher"].map((x) => SubjectTeacher.fromJson(x))),
      employeeNumber: json['employee_no'] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "profile_image": profileImage,
        "specialized_in": specializedIn,
        "user_category": userCategory,
        "email_id": emailId,
        "class_teacher": classTeacher,
        "class_config": classConfig,
        'employee_no': employeeNumber,
        'dob': dob,
        'doj': doj,
        "subject_teacher":
            List<dynamic>.from(subjectTeacher.map((x) => x.toJson())),
      };
  static FetchStaffList singleStaffData = FetchStaffList(
      id: 0,
      userId: '',
      firstName: '',
      mobileNumber: 0,
      profileImage: '',
      specializedIn: 0,
      userCategory: 0,
      emailId: '',
      classTeacher: 'no',
      employeeNumber: '',
      dob: '',
      doj: '',
      classConfig: 0,
      subjectTeacher: []);
}

class SubjectTeacher {
  int classConfig;
  int subject;

  SubjectTeacher({
    required this.classConfig,
    required this.subject,
  });

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) => SubjectTeacher(
        classConfig: json["class_config"],
        subject: json["subject"],
      );

  Map<String, dynamic> toJson() => {
        "class_config": classConfig,
        "subject": subject,
      };
}
