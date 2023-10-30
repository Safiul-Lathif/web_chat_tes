class Image {
  int id;
  String image;

  Image({
    required this.id,
    required this.image,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class SingleNewsEvents {
  int id;
  String user;
  String designation;
  int newsEventsCategory;
  DateTime dateTime;
  String title;
  List<Image> images;
  String description;
  dynamic youtubeLink;
  String important;
  List<Visibility> visibility;
  List<dynamic> addonImages;
  dynamic addonDescription;
  bool like;
  int totalLike;

  SingleNewsEvents({
    required this.id,
    required this.user,
    required this.designation,
    required this.newsEventsCategory,
    required this.dateTime,
    required this.title,
    required this.images,
    required this.description,
    required this.youtubeLink,
    required this.important,
    required this.visibility,
    required this.addonImages,
    required this.addonDescription,
    required this.like,
    required this.totalLike,
  });

  factory SingleNewsEvents.fromJson(Map<String, dynamic> json) =>
      SingleNewsEvents(
        id: json["id"] ?? 0,
        user: json["user"] ?? '',
        designation: json["designation"] ?? '',
        newsEventsCategory: json["news_events_category"] ?? 0,
        dateTime: DateTime.parse(json["datetime"]),
        title: json["title"] ?? '',
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        description: json["description"] ?? '',
        youtubeLink: json["youtube_link"] ?? '',
        important: json["important"] ?? '',
        visibility: List<Visibility>.from(
            json["visibility"].map((x) => Visibility.fromJson(x))),
        addonImages: List<dynamic>.from(json["addon_images"].map((x) => x)),
        addonDescription: json["addon_description"] ?? '',
        like: json["like"] ?? false,
        totalLike: json["total_like"] ?? 0,
      );
}

class Visibility {
  int id;
  String visibilityClass;

  Visibility({
    required this.id,
    required this.visibilityClass,
  });

  factory Visibility.fromJson(Map<String, dynamic> json) => Visibility(
        id: json["id"],
        visibilityClass: json["class"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class": visibilityClass,
      };
}

class SingleEvent {
  SingleEvent(
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
  List<Image> images;
  String description;
  String important;
  int accepted;
  int declined;
  String youtubeLink;
  int acceptStatus;
  List<Visibility> visibility;
  String user;

  factory SingleEvent.fromJson(Map<String, dynamic> json) => SingleEvent(
        id: json["id"] ?? 0,
        newsEventsCategory: json["news_events_category"] ?? 0,
        eventDate: DateTime.parse(json["event_date"]),
        eventTime: json["event_time"] ?? '',
        title: json["title"] ?? '',
        user: json["user"] ?? '',
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        description: json["description"] ?? '',
        important: json["important"] ?? '',
        youtubeLink: json["youtube_link"] ?? '',
        acceptStatus: json["accept_status"] ?? 0,
        accepted: json["accepted"] ?? 0,
        declined: json["declined"] ?? 0,
        visibility: List<Visibility>.from(
            json["visibility"].map((x) => Visibility.fromJson(x))),
      );
}
