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
  String firstName;
  int id;
  int userCategory;
  int mobileNumber;
  int userStatus;
  String parentProfileImage;
  String studentName;
  String dob;
  String className;
  String admissionNumber;
  String parentSearchListClass;
  String classTeacher;
  String studentProfileImage;

  ParentSearchList(
      {required this.firstName,
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
      required this.className});

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
        className: json["class"] ?? '',
      );
}

// class ParentSearchList {
//     String studentName;
//     int id;
//     int userCategory;
//     int mobileNumber;
//     int userStatus;
//     dynamic parentProfileImage;
//     String studentProfileImage;
//     int studentId;
//     int dob;
//     int admissionNumber;
//     int classConfig;
//     String parentSearchListClass;
//     String classTeacher;

//     ParentSearchList({
//         required this.studentName,
//         required this.id,
//         required this.userCategory,
//         required this.mobileNumber,
//         required this.userStatus,
//         required this.parentProfileImage,
//         required this.studentProfileImage,
//         required this.studentId,
//         required this.dob,
//         required this.admissionNumber,
//         required this.classConfig,
//         required this.parentSearchListClass,
//         required this.classTeacher,
//     });

//     factory ParentSearchList.fromJson(Map<String, dynamic> json) => ParentSearchList(
//         studentName: json["student_name"]??'',
//         id: json["id"]??0,
//         userCategory: json["user_category"]??0,
//         mobileNumber: json["mobile_number"]?? 0,
//         userStatus: json["user_status"]??0,
//         parentProfileImage: json["parent_profile_image"]?? '',
//         studentProfileImage: json["student_profile_image"],
//         studentId: json["student_id"],
//         dob: json["dob"],
//         admissionNumber: json["admission_number"],
//         classConfig: json["class_config"],
//         parentSearchListClass: json["class"],
//         classTeacher: json["class_teacher"],
//     );

//    }
