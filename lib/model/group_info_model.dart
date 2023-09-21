class GroupInfoModel {
  GroupInfoModel(
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

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) => GroupInfoModel(
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
