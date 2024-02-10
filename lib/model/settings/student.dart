class ParentCategory {
  List<ParentCategoryList> categories;

  ParentCategory({
    required this.categories,
  });

  factory ParentCategory.fromJson(Map<String, dynamic> json) => ParentCategory(
        categories: List<ParentCategoryList>.from(
            json["categories"].map((x) => ParentCategoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class ParentCategoryList {
  int id;
  String categoryName;

  ParentCategoryList({
    required this.id,
    required this.categoryName,
  });

  factory ParentCategoryList.fromJson(Map<String, dynamic> json) =>
      ParentCategoryList(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}

class ParentList {
  int id;
  String userId;
  String firstName;
  int mobileNumber;
  int classConfig;
  int divisionId;

  ParentList(
      {required this.id,
      required this.userId,
      required this.firstName,
      required this.mobileNumber,
      required this.classConfig,
      required this.divisionId});

  factory ParentList.fromJson(Map<String, dynamic> json) => ParentList(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        firstName: json["first_name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        classConfig: json["class_config"] ?? 0,
        divisionId: json["division_id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "class_config": classConfig,
        "division_id": divisionId
      };
}

class SingleParent {
  int studentId;
  String studentName;
  int fatherMobileNumber;
  String fatherEmailAddress;
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
  String dob;
  String employeeNo;
  String gender;
  String photo;
  String temporaryStudent;
  int classSection;

  SingleParent({
    required this.studentId,
    required this.studentName,
    required this.fatherMobileNumber,
    required this.fatherEmailAddress,
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
    required this.employeeNo,
    required this.gender,
    required this.photo,
    required this.temporaryStudent,
    required this.classSection,
  });

  factory SingleParent.fromJson(Map<String, dynamic> json) => SingleParent(
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
        employeeNo: json["employee_no"],
        gender: json["gender"],
        photo: json["photo"],
        temporaryStudent: json["temporary_student"],
        classSection: json["class_section"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "student_name": studentName,
        "father_mobile_number": fatherMobileNumber,
        "father_email_address": fatherEmailAddress,
        "father_name": fatherName,
        "father_id": fatherId,
        "mother_mobile_number": motherMobileNumber,
        "mother_email_address": motherEmailAddress,
        "mother_name": motherName,
        "mother_id": motherId,
        "guardian_mobile_number": guardianMobileNumber,
        "guardian_email_address": guardianEmailAddress,
        "guardian_name": guardianName,
        "guardian_id": guardianId,
        "admission_number": admissionNumber,
        "roll_no": rollNo,
        "dob": dob,
        "employee_no": employeeNo,
        "gender": gender,
        "photo": photo,
        "temporary_student": temporaryStudent,
        "class_section": classSection,
      };
  static SingleParent student = SingleParent(
      studentId: 0,
      studentName: '',
      fatherMobileNumber: 0,
      fatherEmailAddress: '',
      fatherName: '',
      fatherId: 0,
      motherMobileNumber: 0,
      motherEmailAddress: '',
      motherName: '',
      motherId: 0,
      guardianMobileNumber: 0,
      guardianEmailAddress: '',
      guardianName: '',
      guardianId: 0,
      admissionNumber: '',
      rollNo: 0,
      dob: '',
      employeeNo: '',
      gender: '',
      photo: '',
      temporaryStudent: '',
      classSection: 0);
}
