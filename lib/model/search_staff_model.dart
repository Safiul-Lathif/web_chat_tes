class StaffSearchList {
  int id;
  String firstName;
  int mobileNumber;
  String userCategory;
  int userStatus;
  dynamic dob;
  dynamic doj;
  dynamic employeeNo;
  dynamic department;
  String staffSearchListClass;
  int designation;

  StaffSearchList({
    required this.id,
    required this.firstName,
    required this.mobileNumber,
    required this.userCategory,
    required this.userStatus,
    this.dob,
    this.doj,
    this.employeeNo,
    this.department,
    required this.staffSearchListClass,
    required this.designation,
  });

  factory StaffSearchList.fromJson(Map<String, dynamic> json) =>
      StaffSearchList(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        userCategory: json["user_category"] ?? '',
        userStatus: json["user_status"] ?? 0,
        dob: json["dob"] ?? '',
        doj: json["doj"] ?? '',
        employeeNo: json["employee_no"] ?? '',
        department: json["department"] ?? '',
        staffSearchListClass: json["class"] ?? '',
        designation: json["designation"] ?? 0,
      );
}
