import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/providers/news_provider.dart';
import 'package:structure/utils/enums.dart';

class NewsRepository {

  final NewsProvider provider = NewsProvider();

  DocumentReference queryGetItem(String placeId) {
    return provider.queryGetItem(placeId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? descending, NewsStatus? status, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) {
    return provider.queryGetItems(
      startAfter: startAfter,
      limit: limit,
      descending: descending,
      status: status?.name,
      createdBy: createdBy,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<DocumentSnapshot?> add(NewsItem news) async {
    return await provider.add(news.toMap());
  }

  Future<List<NewsItem>> getItems({DocumentSnapshot? startAfter, int? limit, bool? descending, NewsStatus? status, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) async {
    List<Map> list = await provider.getItems(
      startAfter: startAfter,
      limit: limit,
      descending: descending,
      status: status?.name,
      createdBy: createdBy,
      startDate: startDate,
      endDate: endDate,
    );

    List<NewsItem> news = [];

    for (Map map in list) {
      NewsItem? place = NewsItem.fromMap(map);
      if (place != null) {
        news.add(place);
      }
    }

    return news;
  }

  Future<NewsItem?> get(String newsId) async {
    Map map = await provider.get(newsId);
    return NewsItem.fromMap(map);
  }

  Future<bool> update(NewsItem news) async {
    if (news.document == null) {
      return false;
    }
    return await provider.update(news.document!.id, news.toMap(),);
  }

  Future<bool> delete(NewsItem news) async {
    if (news.document == null) {
      return false;
    }
    return await provider.delete(news.document!.id);
  }

}