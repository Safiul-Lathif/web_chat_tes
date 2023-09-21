class NewsFeed {
  NewsFeed({
    required this.latest,
    required this.old,
  });

  Latest latest;
  List<Latest> old;

  factory NewsFeed.fromJson(Map<String, dynamic> json) => NewsFeed(
        latest: Latest.fromJson(json["latest"]),
        old: List<Latest>.from(json["old"].map((x) => Latest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "latest": latest.toJson(),
        "old": List<dynamic>.from(old.map((x) => x.toJson())),
      };
}

class Latest {
  Latest({
    required this.id,
    required this.newsEventsCategory,
    required this.dateTime,
    required this.title,
    required this.images,
    this.description,
    required this.important,
    required this.addonImages,
    this.addonDescription,
  });

  int id;
  int newsEventsCategory;
  DateTime dateTime;
  String title;
  List<String> images;
  String? description;
  String important;
  List<dynamic> addonImages;
  dynamic addonDescription;

  factory Latest.fromJson(Map<String, dynamic> json) => Latest(
        id: json["id"],
        newsEventsCategory: json["news_events_category"],
        dateTime: DateTime.parse(json["datetime"]),
        title: json["title"],
        images: List<String>.from(json["images"].map((x) => x)),
        description: json["description"],
        important: json["important"],
        addonImages: List<dynamic>.from(json["addon_images"].map((x) => x)),
        addonDescription: json["addon_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "news_events_category": newsEventsCategory,
        "datetime": dateTime.toIso8601String(),
        "title": title,
        "images": List<dynamic>.from(images.map((x) => x)),
        "description": description,
        "important": important,
        "addon_images": List<dynamic>.from(addonImages.map((x) => x)),
        "addon_description": addonDescription,
      };
}
