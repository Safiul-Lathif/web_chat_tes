class NewsImages {
  NewsImages({
    required this.id,
    required this.newsEventsId,
    required this.image,
  });

  int id;
  int newsEventsId;
  String image;

  factory NewsImages.fromJson(Map<String, dynamic> json) => NewsImages(
        id: json["id"],
        newsEventsId: json["news_events_id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "news_events_id": newsEventsId,
        "image": image,
      };
}
