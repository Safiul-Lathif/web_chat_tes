class StudentGroupList {
  int id;
  String name;

  StudentGroupList({
    required this.id,
    required this.name,
  });

  factory StudentGroupList.fromJson(Map<String, dynamic> json) =>
      StudentGroupList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
