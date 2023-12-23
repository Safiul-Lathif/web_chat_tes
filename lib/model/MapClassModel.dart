// class ClassList {
//     ClassList({
//         this.classes,
//     });

//     List<Class>? classes;

//     factory ClassList.fromJson(Map<String, dynamic> json) => ClassList(
//         classes: json["classes"] == null ? [] : List<Class>.from(json["classes"]!.map((x) => Class.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "classes": classes == null ? [] : List<dynamic>.from(classes!.map((x) => x.toJson())),
//     };
// }

// class Class {
//     Class({
//         required this.id,
//         required this.className,
//     });

//     int id;
//     String className;

//     factory Class.fromJson(Map<String, dynamic> json) => Class(
//         id: json["id"],
//         className: json["class_name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "class_name": className,
//     };
// }

