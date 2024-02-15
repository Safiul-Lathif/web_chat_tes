import 'package:ui/model/news&events/single_news_events_model.dart';

import 'img_model.dart';

class NewsEventsData {
  final String title;
  final String description;

  final String link;
  final List<Image> img;
  final List<Visibility> selectedIds;
  final String id;

  NewsEventsData(this.title, this.description, this.link, this.img,
      this.selectedIds, this.id);
}
