class SearchManagementModel {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<ManagementList> data;

  SearchManagementModel({
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

  factory SearchManagementModel.fromJson(Map<String, dynamic> json) =>
      SearchManagementModel(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<ManagementList>.from(
            json["data"].map((x) => ManagementList.fromJson(x))),
      );
}

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
  String userId;
  String emailId;

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
      required this.profileImage,
      required this.userId,
      required this.emailId});

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
      'profileImage': profileImage,
      'userId': userId,
      'email_address': emailId
    };
  }

  static ManagementList managementModelData = ManagementList(
      id: 0,
      firstName: '',
      mobileNumber: 0,
      userStatus: 0,
      profileImage: '',
      designation: '',
      userCategory: 0,
      userId: '',
      dob: '',
      doj: '',
      employeeNo: '',
      emailId: '');
  static ManagementList clearData = ManagementList(
      id: 0,
      firstName: '',
      mobileNumber: 0,
      userStatus: 0,
      profileImage: '',
      userCategory: 0,
      designation: '',
      userId: '',
      dob: '',
      doj: '',
      employeeNo: '',
      emailId: '');
}
