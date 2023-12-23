class DesignationList {
  DesignationList({
    required this.id,
    required this.categoryName,
  });

  int id;
  String categoryName;

  factory DesignationList.fromJson(Map<String, dynamic> json) =>
      DesignationList(
        id: json["id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
      };
}
