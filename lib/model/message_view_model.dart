class UserDetails {
  String name;
  DateTime lastSeen;

  UserDetails({
    required this.name,
    required this.lastSeen,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        name: json["name"],
        lastSeen: DateTime.parse(json["last_seen"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "last_seen": lastSeen.toIso8601String(),
      };
}

class MessageView {
  MessageData message;
  UserDetails userDetails;
  int unReadMessage;

  MessageView({
    required this.message,
    required this.userDetails,
    required this.unReadMessage,
  });

  factory MessageView.fromJson(Map<String, dynamic> json) => MessageView(
        message: MessageData.fromJson(json["message"]),
        userDetails: UserDetails.fromJson(json["user_details"]),
        unReadMessage: json["unreadmessages"],
      );
}

class MessageData {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<Message> data;

  MessageData({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.nextPageUrl,
    required this.prevPageUrl,
    required this.from,
    required this.to,
    required this.data,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
      );
}

class Message {
  String? subTitle;
  int notificationId;
  String user;
  String designation;
  int viewType;
  String messageCategory;
  int messageStatus;
  String? message;
  DateTime dateTime;
  String visibility;
  int important;
  String? caption;
  int approvalStatus;
  List<String>? images;
  int? deliveredUsers;
  int watched;
  int communicationType;
  int subjectId;
  String subjectName;
  String shortName;
  int readCount;
  String? title;
  String? description;
  int? newsEventsCategory;
  int? moduleType;
  String? eventDate;
  String? eventTime;
  int edited;
  int distributionType;

  Message(
      {required this.notificationId,
      required this.user,
      required this.designation,
      required this.viewType,
      required this.messageCategory,
      required this.messageStatus,
      required this.dateTime,
      required this.visibility,
      required this.important,
      required this.communicationType,
      this.caption,
      required this.approvalStatus,
      required this.readCount,
      this.message,
      required this.deliveredUsers,
      required this.watched,
      this.images,
      this.subTitle,
      required this.subjectId,
      required this.subjectName,
      required this.shortName,
      this.title,
      this.description,
      this.newsEventsCategory,
      this.moduleType,
      this.eventDate,
      required this.edited,
      this.eventTime,
      required this.distributionType});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      notificationId: json["notification_id"] ?? 0,
      user: json["user"] ?? '',
      subTitle: json["sub_title"] ?? '',
      designation: json["designation"] ?? '',
      viewType: json["view_type"] ?? 0,
      messageCategory: json["message_category"] ?? '',
      messageStatus: json["message_status"] ?? 0,
      message: json["message"] ?? '',
      dateTime: DateTime.parse(json["date_time"]),
      visibility: json["visiblity"] ?? '',
      important: json["important"] ?? 0,
      caption: json["caption"] ?? '',
      approvalStatus: json["approval_status"] ?? 0,
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      deliveredUsers: json["delivered_users"] ?? 0,
      watched: json["watched"] ?? 0,
      communicationType: json["communication_type"] ?? 0,
      subjectId: json["subject_id"] ?? 0,
      subjectName: json["subject_name"] ?? '',
      shortName: json["short_name"] ?? '',
      readCount: json["read_count"] ?? 0,
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      newsEventsCategory: json["news_events_category"] ?? 0,
      moduleType: json["module_type"] ?? 0,
      edited: json['edited'] ?? 0,
      eventDate: json['event_date'] ?? '',
      eventTime: json["event_time"] ?? '',
      distributionType: json['distribution_type'] ?? 0);
}
