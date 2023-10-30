class ImagesList {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  String nextPageUrl;
  dynamic prevPageUrl;
  int from;
  int to;
  List<NewsImages> data;

  ImagesList({
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

  factory ImagesList.fromJson(Map<String, dynamic> json) => ImagesList(
        total: json["total"] ?? 0,
        perPage: json["per_page"] ?? 0,
        currentPage: json["current_page"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        nextPageUrl: json["next_page_url"] ?? '',
        prevPageUrl: json["prev_page_url"] ?? '',
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        data: List<NewsImages>.from(
            json["data"].map((x) => NewsImages.fromJson(x))),
      );
}

class NewsImages {
  NewsImages(
      {required this.id,
      required this.newsEventsId,
      required this.image,
      required this.dateTime,
      required this.designation,
      required this.user});

  int id;
  int newsEventsId;
  String image;
  String dateTime;
  String designation;
  String user;

  factory NewsImages.fromJson(Map<String, dynamic> json) => NewsImages(
        id: json["id"] ?? 0,
        newsEventsId: json["news_events_id"] ?? 0,
        image: json["image"] ?? '',
        dateTime: json['datetime'] ?? '',
        designation: json['designation'] ?? '',
        user: json['user'] ?? '',
      );
}
