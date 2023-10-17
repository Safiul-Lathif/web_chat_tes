class GroupInfoModel {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<ParticipantsList> data;

  GroupInfoModel({
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

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) => GroupInfoModel(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<ParticipantsList>.from(
            json["data"].map((x) => ParticipantsList.fromJson(x))),
      );
}

class ParticipantsList {
  ParticipantsList(
      {required this.id,
      required this.name,
      required this.mobileNumber,
      required this.designation,
      required this.lastLogin,
      required this.appStatus,
      required this.userRole,
      required this.inactiveDays,
      required this.profile});

  int id;
  String name;
  int mobileNumber;
  String designation;
  String lastLogin;
  String appStatus;
  int userRole;
  int inactiveDays;
  String profile;

  factory ParticipantsList.fromJson(Map<String, dynamic> json) =>
      ParticipantsList(
          id: json["id"] ?? 0,
          name: json["name"] ?? "",
          mobileNumber: json["mobile_number"] ?? 0,
          designation: json["designation"] ?? "",
          lastLogin: json["last_login"] ?? "",
          appStatus: json["app_status"] ?? "",
          userRole: json["user_role"] ?? 0,
          inactiveDays: json["inactive_days"] ?? 0,
          profile: json['profile_image'] ?? '');
}
