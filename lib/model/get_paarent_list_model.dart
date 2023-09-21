class GetParentList {
    GetParentList({
        required this.id,
        required this.userId,
        required this.firstName,
        required this.mobileNumber,
    });

    int id;
    String userId;
    String firstName;
    int mobileNumber;

    factory GetParentList.fromJson(Map<String, dynamic> json) => GetParentList(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "mobile_number": mobileNumber,
    };
}