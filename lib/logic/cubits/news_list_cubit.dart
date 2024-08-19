import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/repositories/news_repository.dart';
import 'package:structure/logic/states/news_list_state.dart';
import 'package:structure/utils/constants.dart';
import 'package:structure/utils/enums.dart';

class NewsListCubit extends Cubit<NewsListState> {

  final NewsRepository repository = NewsRepository();

  int? limitItems;
  DocumentSnapshot? lastDocument;

  NewsListCubit(super.initialState, {this.limitItems}) {
    initData();
  }

  Future initData() async {
    state.isLoading = true;
    emit(state.copy());

    lastDocument = null;
    state.news = [];

    List<NewsItem> news = await repository.getItems(startAfter: lastDocument,
        limit: limitItems?? itemsPerPage, descending:  true, status: state.status,);

    state.news = [... news];
    if (news.isNotEmpty) {
      lastDocument = news.last.document;
    }

    state.isLoading = false;
    emit(state.copy());
  }

  Future loadData() async {
    state.isAdding = true;
    emit(state.copy());

    List<NewsItem> news = await repository.getItems(startAfter: lastDocument,
        limit: itemsPerPage, descending:  true, status: state.status);

    state.news.addAll(news);
    if (news.isNotEmpty) {
      lastDocument = news.last.document;
    }

    state.isAdding = false;
    emit(state.copy());
  }

  deleteItem(NewsItem item) {
    state.news.removeWhere((element) => element.document?.id == item.document?.id);
    emit(state.copy());
  }

  addItem(NewsItem item) async {
    state.news.insert(0, item);
    emit(state.copy());
  }

  updateItem(NewsItem item) {
    int index = state.news.indexWhere((element) => element.document?.id == item.document?.id);

    if (index != -1) {
      state.news[index] = item;
    }

    emit(state.copy());
  }

  setStatus(NewsStatus? status) {
    state.status = status;
    initData();
  }

}