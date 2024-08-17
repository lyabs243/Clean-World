import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/utils/enums.dart';

const collectionNews = "clean_news";

const fieldNewsTitle = "title";
const fieldNewsDescription = "description";
const fieldNewsPhotoUrl = "photo_url";
const fieldNewsDate = "date";
const fieldNewsStatus = "status";
const fieldNewsCreatedBy = "created_by";
const fieldNewsCreatedAt = "created_at";
const fieldNewsDocument = "document";

class NewsItem {

  String title, description, createdBy, photoUrl;
  DateTime createdAt = DateTime.now(), date;
  NewsStatus status;
  DocumentSnapshot? document;

  NewsItem({
    required this.title,
    required this.createdBy,
    required this.date,
    this.description = '',
    this.photoUrl = '',
    this.status = NewsStatus.published,
    this.document,
  });

  static NewsItem? fromMap(Map map) {
    NewsItem? item;

    if (map[fieldNewsTitle] != null && map[fieldNewsCreatedBy] != null && map[fieldNewsDate] != null) {
      item = NewsItem(
        title: map[fieldNewsTitle],
        description: map[fieldNewsDescription],
        createdBy: map[fieldNewsCreatedBy],
        date: map[fieldNewsDate].toDate(),
        document: map[fieldNewsDocument],
        status: NewsStatus.fromString(map[fieldNewsStatus]?? '')?? NewsStatus.published,
        photoUrl: map[fieldNewsPhotoUrl]?? '',
      );

      if (map[fieldNewsCreatedAt] != null) {
        item.createdAt = map[fieldNewsCreatedAt].toDate();
      }
    }

    return item;
  }

  Map<String, dynamic> toMap() {
    return {
      fieldNewsTitle: title,
      fieldNewsDescription: description,
      fieldNewsPhotoUrl: photoUrl,
      fieldNewsDate: date,
      fieldNewsStatus: status.name,
      fieldNewsCreatedBy: createdBy,
      fieldNewsCreatedAt: createdAt,
    };
  }

}