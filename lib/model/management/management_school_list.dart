class ManagementSchoolList {
  int id;
  String schoolName;

  ManagementSchoolList({
    required this.id,
    required this.schoolName,
  });

  factory ManagementSchoolList.fromJson(Map<String, dynamic> json) =>
      ManagementSchoolList(
        id: json["id"],
        schoolName: json["school_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "school_name": schoolName,
      };
}
