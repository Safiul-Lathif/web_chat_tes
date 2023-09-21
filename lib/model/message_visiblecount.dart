class MessageVisibleCount {
  MessageVisibleCount({
    required this.management,
    required this.admin,
    required this.staff,
    required this.parent,
  });

  List<Admin> management;
  List<Admin> admin;
  List<Admin> staff;
  List<Admin> parent;

  factory MessageVisibleCount.fromJson(Map<String, dynamic> json) =>
      MessageVisibleCount(
          management: json['management'] == null
              ? []
              : List<Admin>.from(
                  json["management"].map((x) => Admin.fromJson(x))),
          admin: json['admin'] == null
              ? []
              : List<Admin>.from(json["admin"].map((x) => Admin.fromJson(x))),
          staff: json['staff'] == null
              ? []
              : List<Admin>.from(json["staff"].map((x) => Admin.fromJson(x))),
          parent: json['parent'] == null
              ? []
              : List<Admin>.from(json["parent"].map((x) => Admin.fromJson(x))));
}

class Admin {
  Admin({
    required this.name,
    required this.mobileNumber,
    required this.category,
    required this.id,
  });

  String name;
  int mobileNumber;
  String category;
  int id;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        name: json["name"] ?? '',
        mobileNumber: json["mobile_number"] ?? 0,
        category: json["category"] ?? '',
        id: json["id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "category": category,
        "id": id,
      };
}
