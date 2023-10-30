// class ActionRequiredModel {
//   ActionRequiredModel(
//       {required this.notificationId,
//       required this.user,
//       required this.designation,
//       required this.messageCategory,
//       this.message,
//       required this.dateTime,
//       this.caption,
//       required this.images,
//       required this.groupName});

//   int notificationId;
//   String user;
//   String designation;
//   String messageCategory;
//   dynamic message;
//   DateTime dateTime;
//   dynamic caption;
//   List<String> images;
//   String groupName;

//   factory ActionRequiredModel.fromJson(Map<String, dynamic> json) =>
//       ActionRequiredModel(
//           notificationId: json["notification_id"] ?? 0,
//           user: json["user"] ?? '',
//           designation: json["designation"] ?? '',
//           messageCategory: json["message_category"] ?? '',
//           message: json["message"] ?? '',
//           dateTime: DateTime.parse(json["date_time"]),
//           caption: json["caption"] ?? '',
//           images: json["images"] == null
//               ? []
//               : List<String>.from(json["images"]!.map((x) => x)),
//           groupName: json["group_name"] ?? '');
// }
class ActionRequiredModel {
  int notificationId;
  String user;
  String designation;
  int communicationType;
  String messageCategory;
  String message;
  String groupName;
  DateTime dateTime;
  dynamic caption;
  int? subjectId;
  String? subjectName;
  String? staffName;
  dynamic staffId;
  int actionRequiredModelClass;
  List<String> images;
  String? classteacher;

  ActionRequiredModel({
    required this.notificationId,
    required this.user,
    required this.designation,
    required this.communicationType,
    required this.messageCategory,
    required this.message,
    required this.groupName,
    required this.dateTime,
    this.caption,
    this.subjectId,
    this.subjectName,
    this.staffName,
    this.staffId,
    required this.actionRequiredModelClass,
    required this.images,
    this.classteacher,
  });

  factory ActionRequiredModel.fromJson(Map<String, dynamic> json) =>
      ActionRequiredModel(
        notificationId: json["notification_id"] ?? 0,
        user: json["user"] ?? '',
        designation: json["designation"] ?? '',
        communicationType: json["communication_type"] ?? 0,
        messageCategory: json["message_category"] ?? '',
        message: json["message"] ?? '',
        groupName: json["group_name"] ?? '',
        dateTime: DateTime.parse(json["date_time"]),
        caption: json["caption"] ?? '',
        subjectId: json["subject_id"] ?? 0,
        subjectName: json["subject_name"] ?? "",
        staffName: json["staff_name"] ?? '',
        staffId: json["staff_id"] ?? 0,
        actionRequiredModelClass: json["class"] ?? 0,
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        classteacher: json["classteacher"] ?? '',
      );
}
