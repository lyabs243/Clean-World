import 'package:structure/data/models/news_item.dart';
import 'package:structure/utils/my_material.dart';

class NewsListState {

  bool isLoading, isAdding;
  NewsStatus? status;
  List<NewsItem> news = [];

  NewsListState({this.isLoading = true, this.status = NewsStatus.published, this.isAdding = false});

  NewsListState copy() {
    NewsListState copy = NewsListState(isLoading: isLoading, status: status, isAdding: isAdding,);

    copy.news = news;

    return copy;
  }

}