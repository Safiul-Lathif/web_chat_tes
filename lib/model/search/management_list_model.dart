class ManagementList {
  int id;
  String firstName;
  int mobileNumber;
  int? userCategory;
  int userStatus;
  dynamic dob;
  dynamic doj;
  String? employeeNo;
  String designation;
  String profileImage;

  ManagementList(
      {required this.id,
      required this.firstName,
      required this.mobileNumber,
      this.userCategory,
      required this.userStatus,
      this.dob,
      this.doj,
      this.employeeNo,
      required this.designation,
      required this.profileImage});

  factory ManagementList.fromJson(Map<String, dynamic> json) => ManagementList(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        userCategory: json["user_category"] ?? 0,
        userStatus: json["user_status"] ?? 0,
        dob: json["dob"] ?? '',
        doj: json["doj"] ?? '',
        employeeNo: json["employee_no"] ?? '',
        designation: json["designation"] ?? '',
        profileImage: json["profile_image"] ?? '',
      );
}
