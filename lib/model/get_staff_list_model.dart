class OnboardingstaffList {
  OnboardingstaffList({
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

  factory OnboardingstaffList.fromJson(Map<String, dynamic> json) =>
      OnboardingstaffList(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "profile_image": profileImage,
      };
}
