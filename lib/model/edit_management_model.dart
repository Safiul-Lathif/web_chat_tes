
class EditManagementList {
    EditManagementList({
        required this.id,
        required this.managementPersonName,
        required this.photo,
        required this.mobileNumber,
    });

    int id;
    String managementPersonName;
    String photo;
    int mobileNumber;

    factory EditManagementList.fromJson(Map<String, dynamic> json) => EditManagementList(
        id: json["id"],
        managementPersonName: json["management_person_name"],
        photo: json["photo"],
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "management_person_name": managementPersonName,
        "photo": photo,
        "mobile_number": mobileNumber,
    };
}