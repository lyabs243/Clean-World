import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/repositories/news_repository.dart';
import 'package:structure/logic/responses/news_response.dart';
import 'package:structure/logic/states/news_state.dart';
import 'package:structure/utils/my_material.dart';

class NewsCubit extends Cubit<NewsState> {

  final NewsRepository repository = NewsRepository();
  StreamSubscription? subscription;

  NewsCubit(super.initialState,) {
    initData();
  }

  initData() async {
    listenChanges();
  }

  listenChanges() async {

    if (subscription != null) {
      subscription!.cancel();
    }

    subscription = repository.queryGetItem(state.news.document!.id).snapshots().listen((element) async {

      NewsItem? item = NewsItem.fromMap((element.data()?? {}) as Map);
      if (item != null) {
        item.document = element;
        state.news = item;
        emit(state.copy());
      }

    });

  }

  delete() async {
    bool result = await repository.delete(state.news);
    if (result) {
      showMessage(code: NewsCode.deleted);
    } else {
      showMessage(code: NewsCode.error);
    }
  }

  showMessage({NewsCode? code, MessageType type = MessageType.toast}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (code != null) {
      state.response = NewsResponse(code: code, messageType: type);
    }

    emit(state.copy());
  }

  @override
  Future<void> close() {
    if (subscription != null) {
      subscription!.cancel();
    }
    return super.close();
  }

}