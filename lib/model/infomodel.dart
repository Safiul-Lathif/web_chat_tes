class Info {
  Info({
    required this.messageInfo,
  });

  MessageInfo messageInfo;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        messageInfo: MessageInfo.fromJson(json["message_info"]),
      );
}

class MessageInfo {
  MessageInfo({
    required this.initiatedBy,
    required this.initiatedUserCategory,
    required this.initiatedOn,
    required this.approvedBy,
    required this.approverUserCategory,
    required this.area,
    required this.approvedAt,
    required this.deletedBy,
    required this.deletedOn,
  });

  String initiatedBy;
  String initiatedUserCategory;
  DateTime initiatedOn;
  String approvedBy;
  String approverUserCategory;
  String area;
  String approvedAt;
  String deletedBy;
  String deletedOn;

  factory MessageInfo.fromJson(Map<String, dynamic> json) => MessageInfo(
        initiatedBy: json["initated_by"] ?? '',
        initiatedUserCategory: json["initated_user_category"] ?? '',
        initiatedOn: DateTime.parse(json["initated_on"]),
        approvedBy: json["approved_by"] ?? '',
        approverUserCategory: json["approver_user_category"] ?? '',
        area: json["area"] ?? '',
        approvedAt: json["approved_at"] ?? '',
        deletedBy: json["deleted_by"] ?? '',
        deletedOn: json["deleted_on"] ?? '',
      );
}
