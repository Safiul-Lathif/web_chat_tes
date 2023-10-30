class EventsFeedList {
  Events upcomingEvents;
  Events completedEvents;

  EventsFeedList({
    required this.upcomingEvents,
    required this.completedEvents,
  });

  factory EventsFeedList.fromJson(Map<String, dynamic> json) => EventsFeedList(
        upcomingEvents: Events.fromJson(json["upcoming_events"]),
        completedEvents: Events.fromJson(json["completed_events"]),
      );
}

class Events {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  dynamic nextPageUrl;
  dynamic prevPageUrl;
  int? from;
  int? to;
  List<EventFeed> data;

  Events({
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

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<EventFeed>.from(
            json["data"].map((x) => EventFeed.fromJson(x))),
      );
}

class EventFeed {
  EventFeed(
      {required this.id,
      required this.newsEventsCategory,
      required this.eventDate,
      required this.eventTime,
      required this.title,
      required this.images,
      required this.description,
      required this.important,
      required this.accepted,
      required this.youtubeLink,
      required this.visibility,
      required this.user,
      required this.declined,
      required this.acceptStatus});

  int id;
  int newsEventsCategory;
  DateTime eventDate;
  String eventTime;
  String title;
  List<String> images;
  String description;
  String important;
  int accepted;
  int declined;
  String youtubeLink;
  int acceptStatus;
  String visibility;
  String user;

  factory EventFeed.fromJson(Map<String, dynamic> json) => EventFeed(
      id: json["id"] ?? 0,
      newsEventsCategory: json["news_events_category"] ?? 0,
      eventDate: DateTime.parse(json["event_date"]),
      eventTime: json["event_time"] ?? '',
      title: json["title"] ?? '',
      user: json["user"] ?? '',
      images: List<String>.from(json["images"].map((x) => x)),
      description: json["description"] ?? '',
      important: json["important"] ?? '',
      youtubeLink: json["youtube_link"] ?? '',
      acceptStatus: json["accept_status"] ?? 0,
      accepted: json["accepted"] ?? 0,
      declined: json["declined"] ?? 0,
      visibility: json["visibility"] ?? '');
}
