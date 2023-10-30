class SearchStaffModel {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<StaffSearchList> data;

  SearchStaffModel({
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

  factory SearchStaffModel.fromJson(Map<String, dynamic> json) =>
      SearchStaffModel(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<StaffSearchList>.from(
            json["data"].map((x) => StaffSearchList.fromJson(x))),
      );
}

class StaffSearchList {
  StaffSearchList(
      {required this.id,
      required this.firstName,
      required this.mobileNumber,
      required this.profileImage,
      required this.userCategory,
      required this.userStatus,
      required this.userId,
      required this.employeeNo});

  int id;
  String firstName;
  int mobileNumber;
  String userCategory;
  int userStatus;
  String profileImage;
  String userId;
  String employeeNo;

  factory StaffSearchList.fromJson(Map<String, dynamic> json) =>
      StaffSearchList(
          id: json["id"] ?? 0,
          firstName: json["first_name"] ?? '',
          mobileNumber: json["mobile_number"] ?? 0,
          userCategory: json["user_category"] ?? '',
          profileImage: json['profile_image'] ?? '',
          userStatus: json["user_status"] ?? 0,
          employeeNo: json['employee_no'] ?? '',
          userId: json["user_id"] ?? '');
}
