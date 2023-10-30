class SearchAdminModel {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<AdminList> data;

  SearchAdminModel({
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

  factory SearchAdminModel.fromJson(Map<String, dynamic> json) =>
      SearchAdminModel(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<AdminList>.from(
            json["data"].map((x) => AdminList.fromJson(x))),
      );
}

class AdminList {
  int id;
  String firstName;
  int mobileNumber;
  int userStatus;
  dynamic dob;
  dynamic doj;
  dynamic employeeNo;
  String designation;
  String profileImage;
  String userId;

  AdminList(
      {required this.id,
      required this.firstName,
      required this.mobileNumber,
      required this.userStatus,
      this.dob,
      this.doj,
      this.employeeNo,
      required this.profileImage,
      required this.designation,
      required this.userId});

  factory AdminList.fromJson(Map<String, dynamic> json) => AdminList(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        userStatus: json["user_status"] ?? 0,
        dob: json["dob"] ?? '',
        doj: json["doj"] ?? '',
        employeeNo: json["employee_no"] ?? '',
        designation: json["designation"] ?? '',
        profileImage: json["profile_image"] ?? '',
        userId: json["user_id"] ?? '',
      );
}
