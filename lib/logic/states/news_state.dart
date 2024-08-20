import 'package:structure/data/models/news_item.dart';
import 'package:structure/logic/responses/news_response.dart';

import '../../utils/my_material.dart';

class NewsState {

  bool isLoading;
  NewsItem news;
  NewsResponse? response;

  NewsState({required this.news, this.isLoading = true, this.response});

  NewsState copy() {
    NewsState copy = NewsState(news: news, isLoading: isLoading, response: response);

    return copy;
  }

  ImageProvider get image {

    if (news.photoUrl.isNotEmpty) {
      return NetworkImage(news.photoUrl);
    }

    return AssetImage(PathImage.notFound);
  }

}