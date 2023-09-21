class ParentSearchList {
  String firstName;
  int id;
  int userCategory;
  int mobileNumber;
  int userStatus;
  String parentProfileImage;
  String studentName;
  String dob;
  String admissionNumber;
  String parentSearchListClass;
  String classTeacher;
  String studentProfileImage;

  ParentSearchList({
    required this.firstName,
    required this.id,
    required this.userCategory,
    required this.mobileNumber,
    required this.userStatus,
    required this.parentProfileImage,
    required this.studentName,
    required this.dob,
    required this.admissionNumber,
    required this.parentSearchListClass,
    required this.classTeacher,
    required this.studentProfileImage,
  });

  factory ParentSearchList.fromJson(Map<String, dynamic> json) =>
      ParentSearchList(
        firstName: json["first_name"] ?? '',
        id: json["id"] ?? 0,
        userCategory: json["user_category"] ?? 0,
        mobileNumber: json["mobile_number"] ?? 0,
        userStatus: json["user_status"] ?? 0,
        parentProfileImage: json["parent_profile_image"] ?? '',
        studentName: json["student_name"] ?? '',
        dob: json['dob'] ?? '',
        admissionNumber: json["admission_number"] ?? '',
        parentSearchListClass: json["class"] ?? '',
        classTeacher: json["class_teacher"] ?? '',
        studentProfileImage: json["student_profile_image"] ?? '',
      );
}
