class ManagementListModel {
  ManagementListModel({
    required this.id,
    required this.firstName,
    required this.mobileNumber,
    required this.profileImage,
  });

  int id;
  String firstName;
  int mobileNumber;
  String profileImage;

  factory ManagementListModel.fromJson(Map<String, dynamic> json) =>
      ManagementListModel(
        id: json["id"],
        firstName: json["management_person_name"],
        mobileNumber: json["mobile_number"],
        profileImage: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "management_person_name": firstName,
        "mobile_number": mobileNumber,
        "photo": profileImage,
      };
}
