class SearchParentModel {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<ParentSearchList> data;

  SearchParentModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.from,
    required this.to,
    required this.data,
  });

  factory SearchParentModel.fromJson(Map<String, dynamic> json) =>
      SearchParentModel(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<ParentSearchList>.from(
            json["data"].map((x) => ParentSearchList.fromJson(x))),
      );
}

class ParentSearchList {
  String studentName;
  int id;
  int userCategory;
  int mobileNumber;
  int userStatus;
  String parentProfileImage;
  String studentProfileImage;
  int studentId;
  String dob;
  String admissionNumber;
  int classConfig;
  String firstName;
  String emailId;
  String className;
  String classTeacher;

  ParentSearchList({
    required this.studentName,
    required this.id,
    required this.userCategory,
    required this.mobileNumber,
    required this.userStatus,
    required this.parentProfileImage,
    required this.studentProfileImage,
    required this.studentId,
    required this.dob,
    required this.admissionNumber,
    required this.classConfig,
    required this.firstName,
    required this.emailId,
    required this.className,
    required this.classTeacher,
  });

  factory ParentSearchList.fromJson(Map<String, dynamic> json) =>
      ParentSearchList(
        studentName: json["student_name"] ?? '',
        id: json["id"] ?? 0,
        userCategory: json["user_category"] ?? 0,
        mobileNumber: json["mobile_number"] ?? 0,
        userStatus: json["user_status"] ?? 0,
        parentProfileImage: json["parent_profile_image"] ?? '',
        studentProfileImage: json["student_profile_image"] ?? '',
        studentId: json["student_id"] ?? 0,
        dob: json['dob'] ?? '',
        admissionNumber: json["admission_number"] ?? '',
        classConfig: json["class_config"] ?? 0,
        firstName: json["first_name"] ?? '',
        emailId: json["email_id"] ?? '',
        className: json["class"] ?? '',
        classTeacher: json["class_teacher"] ?? '',
      );

  static ParentSearchList parentModelData = ParentSearchList(
      firstName: '',
      id: 0,
      userCategory: 0,
      mobileNumber: 0,
      userStatus: 0,
      parentProfileImage: '',
      studentName: '',
      dob: '',
      admissionNumber: '',
      classConfig: 0,
      classTeacher: '',
      studentProfileImage: '',
      emailId: '',
      className: '',
      studentId: 0);
  static ParentSearchList clearData = ParentSearchList(
      firstName: '',
      id: 0,
      userCategory: 0,
      mobileNumber: 0,
      userStatus: 0,
      parentProfileImage: '',
      studentName: '',
      dob: '',
      admissionNumber: '',
      classConfig: 0,
      emailId: '',
      classTeacher: '',
      studentProfileImage: '',
      className: '',
      studentId: 0);
}
