class ActionRequiredModel {
  ActionRequiredModel(
      {required this.notificationId,
      required this.user,
      required this.designation,
      required this.messageCategory,
      this.message,
      required this.dateTime,
      this.caption,
      required this.images,
      required this.groupName});

  int notificationId;
  String user;
  String designation;
  String messageCategory;
  dynamic message;
  DateTime dateTime;
  dynamic caption;
  List<String> images;
  String groupName;

  factory ActionRequiredModel.fromJson(Map<String, dynamic> json) =>
      ActionRequiredModel(
          notificationId: json["notification_id"] ?? 0,
          user: json["user"] ?? '',
          designation: json["designation"] ?? '',
          messageCategory: json["message_category"] ?? '',
          message: json["message"] ?? '',
          dateTime: DateTime.parse(json["date_time"]),
          caption: json["caption"] ?? '',
          images: json["images"] == null
              ? []
              : List<String>.from(json["images"]!.map((x) => x)),
          groupName: json["group_name"] ?? '');
}
