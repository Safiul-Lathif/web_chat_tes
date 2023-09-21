class SiblingDetail {
  SiblingDetail({
    required this.id,
    required this.firstName,
    required this.gender,
    required this.classConfig,
  });

  int id;
  String firstName;
  int gender;
  int classConfig;

  factory SiblingDetail.fromJson(Map<String, dynamic> json) => SiblingDetail(
        id: json["id"],
        firstName: json["first_name"],
        gender: json["gender"],
        classConfig: json["class_config"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "gender": gender,
        "class_config": classConfig,
      };
}
