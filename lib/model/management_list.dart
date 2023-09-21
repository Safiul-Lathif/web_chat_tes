class ManagementList {
  ManagementList({
    required this.id,
    required this.managementPersonName,
    required this.photo,
    required this.emailAddress,
    required this.designation,
    required this.mobileNumber,
  });

  int id;
  String managementPersonName;
  String photo;
  String emailAddress;
  int designation;
  int mobileNumber;

  factory ManagementList.fromJson(Map<String, dynamic> json) => ManagementList(
        id: json["id"] ?? 0,
        managementPersonName: json["management_person_name"] ?? '',
        photo: json["photo"] ?? '',
        emailAddress: json["email_address"] ?? 'N/A',
        designation: json["designation"] ?? 0,
        mobileNumber: json["mobile_number"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "management_person_name": managementPersonName,
        "photo": photo,
        "email_address": emailAddress,
        "designation": designation,
        "mobile_number": mobileNumber,
      };
}
