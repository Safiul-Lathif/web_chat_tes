class StaffListModel {
  StaffListModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.mobileNumber,
    required this.profileImage,
  });

  int id;
  String userId;
  String firstName;
  int mobileNumber;
  String profileImage;

  factory StaffListModel.fromJson(Map<String, dynamic> json) => StaffListModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? '',
        firstName: json["first_name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        profileImage: json["profile_image"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "profile_image": profileImage,
      };
}
