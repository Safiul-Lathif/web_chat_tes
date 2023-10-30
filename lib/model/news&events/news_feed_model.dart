class NewsFeedMain {
  Latest latest;
  Old old;

  NewsFeedMain({
    required this.latest,
    required this.old,
  });

  factory NewsFeedMain.fromJson(Map<String, dynamic> json) => NewsFeedMain(
        latest: Latest.fromJson(json["latest"]),
        old: Old.fromJson(json["old"]),
      );
}

class Old {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  String prevPageUrl;
  int from;
  int to;
  List<Latest> data;

  Old({
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

  factory Old.fromJson(Map<String, dynamic> json) => Old(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<Latest>.from(json["data"].map((x) => Latest.fromJson(x))),
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
      required this.user,
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
  String user;

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
      user: json['user'] ?? '',
      visibility: json["visibility"] ?? "",
      totalLike: json["total_like"] ?? 0);
}
