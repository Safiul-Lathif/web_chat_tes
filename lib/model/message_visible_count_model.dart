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
        management:
            List<Admin>.from(json["management"].map((x) => Admin.fromJson(x))),
        admin: List<Admin>.from(json["admin"].map((x) => Admin.fromJson(x))),
        staff: List<Admin>.from(json["staff"].map((x) => Admin.fromJson(x))),
        parent: List<Admin>.from(json["parent"].map((x) => Admin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "management": List<dynamic>.from(management.map((x) => x.toJson())),
        "admin": List<dynamic>.from(admin.map((x) => x.toJson())),
        "staff": List<dynamic>.from(staff.map((x) => x.toJson())),
        "parent": List<dynamic>.from(parent.map((x) => x.toJson())),
      };
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
        name: json["name"],
        mobileNumber: json["mobile_number"],
        category: json["category"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "category": category,
        "id": id,
      };
}
