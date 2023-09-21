class EventsFeedList {
  EventsFeedList({
    required this.upcomingEvents,
    required this.completedEvents,
  });

  List<UpcomingEvent> upcomingEvents;
  List<UpcomingEvent> completedEvents;

  factory EventsFeedList.fromJson(Map<String, dynamic> json) => EventsFeedList(
        upcomingEvents: List<UpcomingEvent>.from(
            json["upcoming_events"].map((x) => UpcomingEvent.fromJson(x))),
        completedEvents: List<UpcomingEvent>.from(
            json["completed_events"].map((x) => UpcomingEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "upcoming_events":
            List<dynamic>.from(upcomingEvents.map((x) => x.toJson())),
        "completed_events":
            List<dynamic>.from(completedEvents.map((x) => x.toJson())),
      };
}

class UpcomingEvent {
  UpcomingEvent(
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

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) => UpcomingEvent(
      id: json["id"] ?? 0,
      newsEventsCategory: json["news_events_category"] ?? 0,
      eventDate: DateTime.parse(json["event_date"]),
      eventTime: json["event_time"] ?? '',
      title: json["title"] ?? '',
      images: List<String>.from(json["images"].map((x) => x)),
      description: json["description"] ?? '',
      important: json["important"] ?? '',
      youtubeLink: json["youtube_link"] ?? '',
      acceptStatus: json["accept_status"] ?? 0,
      accepted: json["accepted"] ?? 0,
      declined: json["declined"] ?? 0,
      visibility: json["visibility"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "news_events_category": newsEventsCategory,
        "event_date":
            "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "event_time": eventTime,
        "title": title,
        "images": List<dynamic>.from(images.map((x) => x)),
        "description": description,
        "important": important,
        "accepted": accepted,
        "declined": declined,
        "youtube_link": youtubeLink,
        "accept_status": acceptStatus,
        "visibility": visibility
      };
}
