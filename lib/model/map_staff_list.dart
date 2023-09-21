class MapStaffList {
  MapStaffList({
    required this.staffName,
    required this.staffId,
    required this.isChecked,
  });

  String staffName;
  int staffId;
  bool isChecked;

  factory MapStaffList.fromJson(Map<String, dynamic> json) => MapStaffList(
        staffName: json["staff_name"],
        staffId: json["staff_id"],
        isChecked: json["is_checked"],
      );

  Map<String, dynamic> toJson() => {
        "staff_name": staffName,
        "staff_id": staffId,
        "is_checked": isChecked,
      };
}

class SelectedStaffList {
  SelectedStaffList({
    required this.subjectId,
    required this.staffId,
  });

  String subjectId;
  String staffId;

 factory SelectedStaffList.fromJson(Map<String, dynamic> json) => SelectedStaffList(
        subjectId: json["id"],
        staffId: json["staff_id"],
      );

}
