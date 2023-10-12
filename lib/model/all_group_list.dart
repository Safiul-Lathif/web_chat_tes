class GroupList {
  List<Class> classes;

  GroupList({
    required this.classes,
  });

  factory GroupList.fromJson(Map<String, dynamic> json) => GroupList(
        classes:
            List<Class>.from(json["classes"].map((x) => Class.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "classes": List<dynamic>.from(classes.map((x) => x.toJson())),
      };
}

class Class {
  int id;
  String className;
  int totalCount;

  Class({required this.id, required this.className, required this.totalCount});

  factory Class.fromJson(Map<String, dynamic> json) => Class(
      id: json["id"],
      className: json["class_name"],
      totalCount: json["total_users"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "class_name": className, "total_users": totalCount};
}
