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
  int id;
  String firstName;
  int mobileNumber;
  String userCategory;
  int userStatus;
  dynamic dob;
  dynamic doj;
  String? employeeNo;
  int designation;
  String profileImage;
  String userId;
  String emailId;

  StaffSearchList(
      {required this.id,
      required this.firstName,
      required this.mobileNumber,
      required this.userCategory,
      required this.userStatus,
      this.dob,
      this.doj,
      this.employeeNo,
      required this.designation,
      required this.profileImage,
      required this.userId,
      required this.emailId});

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
          designation: json["designation"] ?? 0,
          profileImage: json["profile_image"] ?? '',
          userId: json["user_id"] ?? '',
          emailId: json['email_id'] ?? '');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'mobileNumber': mobileNumber,
      'userCategory': userCategory,
      'userStatus': userStatus,
      'dob': dob,
      'doj': doj,
      'employeeNo': employeeNo,
      'designation': designation,
      'profile_image': profileImage,
      'userId': userId,
      'email_address': emailId
    };
  }

  static StaffSearchList staffModelData = StaffSearchList(
      id: 0,
      firstName: '',
      mobileNumber: 0,
      userStatus: 0,
      profileImage: '',
      designation: 0,
      userCategory: '',
      userId: '',
      dob: '',
      doj: '',
      employeeNo: '',
      emailId: '');
  static StaffSearchList clearData = StaffSearchList(
      id: 0,
      firstName: '',
      mobileNumber: 0,
      userStatus: 0,
      profileImage: '',
      userCategory: '',
      designation: 0,
      userId: '',
      dob: '',
      doj: '',
      employeeNo: '',
      emailId: '');
}
