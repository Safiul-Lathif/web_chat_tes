
class FetchStaffList {
    FetchStaffList({
        required this.id,
        required this.userId,
        required this.firstName,
        required this.mobileNumber,
        required this.profileImage,
        required this.specializedIn,
        required this.userCategory,
        required this.emailId,
        required this.classTeacher,
        required this.classConfig,
    });

    int id;
    String userId;
    String firstName;
    int mobileNumber;
    String profileImage;
    int specializedIn;
    int userCategory;
    String emailId;
    String classTeacher;
    int classConfig;

    factory FetchStaffList.fromJson(Map<String, dynamic> json) => FetchStaffList(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
        profileImage: json["profile_image"],
        specializedIn: json["specialized_in"],
        userCategory: json["user_category"],
        emailId: json["email_id"],
        classTeacher: json["class_teacher"],
        classConfig: json["class_config"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
        "profile_image": profileImage,
        "specialized_in": specializedIn,
        "user_category": userCategory,
        "email_id": emailId,
        "class_teacher": classTeacher,
        "class_config": classConfig,
    };
}
