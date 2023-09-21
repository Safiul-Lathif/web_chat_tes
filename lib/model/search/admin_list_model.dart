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

  AdminList({
    required this.id,
    required this.firstName,
    required this.mobileNumber,
    required this.userStatus,
    this.dob,
    this.doj,
    this.employeeNo,
    required this.profileImage,
    required this.designation,
  });

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
      );
}
