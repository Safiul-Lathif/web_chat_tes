class MessageReadinfo {
  MessageReadinfo({
    required this.deliveredUsers,
  });

  List<DeliveredUser> deliveredUsers;

  factory MessageReadinfo.fromJson(Map<String, dynamic> json) =>
      MessageReadinfo(
        deliveredUsers: List<DeliveredUser>.from(
            json["delivered_users"].map((x) => DeliveredUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "delivered_users":
            List<dynamic>.from(deliveredUsers.map((x) => x.toJson())),
      };
}

class DeliveredUser {
  DeliveredUser({
    required this.name,
    required this.designation,
    required this.mobileNo,
    required this.messageStatus,
    required this.viewTime,
  });

  String name;
  String designation;
  int mobileNo;
  int messageStatus;
  DateTime viewTime;

  factory DeliveredUser.fromJson(Map<String, dynamic> json) => DeliveredUser(
        name: json["name"],
        designation: json["designation"],
        mobileNo: json["mobile_no"],
        messageStatus: json["message_status"],
        viewTime: DateTime.parse(json["view_time"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "designation": designation,
        "mobile_no": mobileNo,
        "message_status": messageStatus,
        "view_time": viewTime.toIso8601String(),
      };
}
