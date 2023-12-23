class ClassList {
  ClassList({
    this.classes,
  });

  List<ListsClass>? classes;

  factory ClassList.fromJson(Map<String, dynamic> json) => ClassList(
        classes: json["classes"] == null
            ? []
            : List<ListsClass>.from(
                json["classes"]!.map((x) => ListsClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "classes": classes == null
            ? []
            : List<dynamic>.from(classes!.map((x) => x.toJson())),
      };
}

class ListsClass {
  ListsClass({
    required this.id,
    required this.className,
  });

  int id;
  String className;

  factory ListsClass.fromJson(Map<String, dynamic> json) => ListsClass(
        id: json["id"],
        className: json["class_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class_name": className,
      };
}
