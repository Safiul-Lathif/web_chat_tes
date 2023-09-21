class Fetchmanagement {
    Fetchmanagement({
        required this.id,
        required this.userId,
        required this.firstName,
        required this.mobileNumber,
        required this.profileImage,
        this.userCategory,
        this.emailId,
    });

    int id;
    String userId;
    String firstName;
    int mobileNumber;
    String profileImage;
    dynamic userCategory;
    dynamic emailId;

    factory Fetchmanagement.fromJson(Map<String, dynamic> json) => Fetchmanagement(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
        profileImage: json["profile_image"],
        userCategory: json["user_category"],
        emailId: json["email_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "profile_image": profileImage,
        "user_category": userCategory,
        "email_id": emailId,
    };
}
