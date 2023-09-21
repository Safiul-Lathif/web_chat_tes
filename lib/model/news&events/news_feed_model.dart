class NewsFeedMain {
  NewsFeedMain({
    required this.latest,
    required this.old,
  });

  Latest latest;
  List<Latest> old;

  factory NewsFeedMain.fromJson(Map<String, dynamic> json) => NewsFeedMain(
        latest: Latest.fromJson(json["latest"]),
        old: List<Latest>.from(json["old"].map((x) => Latest.fromJson(x))),
      );
}

class Latest {
  Latest(
      {required this.id,
      required this.newsEventsCategory,
      required this.dateTime,
      required this.title,
      required this.images,
      this.description,
      required this.important,
      required this.addonImages,
      this.addonDescription,
      required this.like,
      required this.totalLike,
      required this.visibility,
      required this.youtubeLink});

  int id;
  int newsEventsCategory;
  DateTime dateTime;
  String title;
  List<String> images;
  String? description;
  String important;
  List<dynamic> addonImages;
  bool like;
  int totalLike;
  String? addonDescription;
  String youtubeLink;
  String visibility;

  factory Latest.fromJson(Map<String, dynamic> json) => Latest(
      id: json["id"] ?? 0,
      newsEventsCategory: json["news_events_category"],
      dateTime: DateTime.parse(json["datetime"]),
      title: json["title"] ?? '',
      images: List<String>.from(json["images"].map((x) => x)),
      description: json["description"] ?? '',
      important: json["important"] ?? '',
      addonImages: List<dynamic>.from(json["addon_images"].map((x) => x)),
      addonDescription: json["addon_description"] ?? '',
      like: json["like"],
      youtubeLink: json["youtube_link"] ?? '',
      visibility: json["visibility"] ?? "",
      totalLike: json["total_like"] ?? 0);
}
