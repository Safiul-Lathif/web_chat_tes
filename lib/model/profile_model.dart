class ProfileModel {
  String name;
  int mobileNo;
  String profile;
  String lastLogin;
  dynamic designation;
  dynamic dob;
  dynamic doj;
  dynamic employeeNo;
  dynamic classTeacher;
  dynamic department;
  dynamic className;

  ProfileModel(
      {required this.name,
      required this.mobileNo,
      required this.profile,
      required this.lastLogin,
      required this.designation,
      this.dob,
      this.doj,
      this.employeeNo,
      this.department,
      this.classTeacher,
      this.className});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["name"] ?? '',
        mobileNo: json["mobile_no"] ?? 0,
        profile: json["profile"] ?? '',
        lastLogin: json["last_login"] ?? '',
        designation: json["designation"] ?? '',
        dob: json["dob"] ?? '',
        doj: json["doj"] ?? '',
        employeeNo: json["employee_no"] ?? '',
        department: json["department"] ?? '',
        className: json["class"] ?? '',
      );
}
