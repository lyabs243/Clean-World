import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/repositories/news_repository.dart';
import 'package:structure/data/repositories/notification_repository.dart';
import 'package:structure/data/repositories/storage_repository.dart';
import 'package:structure/logic/responses/set_news_response.dart';
import 'package:structure/logic/states/set_news_state.dart';

import '../../utils/my_material.dart';

class SetNewsCubit extends Cubit<SetNewsState> {

  final UserItem user;
  final StorageRepository storageRepository = StorageRepository();
  final NotificationRepository notificationRepository = NotificationRepository();
  final NewsRepository repository = NewsRepository();
  final ImagePicker picker = ImagePicker();

  SetNewsCubit(super.initialState, {required this.user}) {
    initData();
  }

  initData() async {

    if (state.news != null) {
      state.titleEditingController.text = state.news!.title;
      state.controller = QuillController(
        document: state.news!.contentQuill,
        selection: const TextSelection.collapsed(offset: 0),
      );
      state.publicationDate = state.news!.date;
      state.status = state.news!.status;
    }

    emit(state.copy());
  }

  setStatus(NewsStatus status) {
    state.status = status;
    emit(state.copy());
  }

  setDate(DateTime date) {
    state.publicationDate = date;
    emit(state.copy());
  }

  pickFile() async {
    state.imagePickerResult = await picker.pickImage(source: ImageSource.gallery);
    emit(state.copy());
  }

  removeFile() {
    state.imagePickerResult = null;
    emit(state.copy());
  }

  showMessage({SetNewsCode? code, MessageType type = MessageType.dialog}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (code != null) {
      state.response = SetNewsResponse(code: code, messageType: type);
    }

    state.isLoading = false;
    emit(state.copy());
  }

  setNews() async {
    if (state.isLoading) {
      return;
    }

    if (state.titleEditingController.text.isEmpty ||
        (
            state.imagePickerResult == null &&
            state.news == null
        )
    ) {
      showMessage(code: SetNewsCode.fillRequiredFields);
      return;
    }

    state.isLoading = true;
    emit(state.copy());

    //upload images
    String urlImage = state.news?.photoUrl?? '';
    if (state.imagePickerResult != null) {
      urlImage = await storageRepository.uploadFile(
        bytes: await state.imagePickerResult!.readAsBytes(),
        fileType: state.imagePickerResult?.mimeType?? '',
        storageReference: storageRefNews,
        name: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (urlImage.isEmpty) {
        showMessage(code: SetNewsCode.errorUpload,);
        return;
      }
    }

    if (state.news == null) {
      _add(urlImage);
    }
    else {
      _edit(urlImage);
    }

  }

  _add(String urlImage) async {
    String description = jsonEncode(state.controller.document.toDelta().toJson());
    NewsItem news = NewsItem(title: state.titleEditingController.text, createdBy: user.authId,
      date: state.publicationDate, photoUrl: urlImage, status: state.status, description: description,);
    DocumentSnapshot? document = await repository.add(news);

    if (document != null) {
      news.document = document;
      state.news = news;
      state.imagePickerResult = null;

      // send notification
      String notificationDescription = news.descriptionPlainText;
      if (notificationDescription.length > 100) {
        notificationDescription = notificationDescription.substring(0, 100);
      }
      if (state.status == NewsStatus.published) {
        NotificationItem notification = NotificationItem(
          type: NotificationType.news,
          data: {'news_id': document.id, 'type': NotificationType.news.code},
          title: news.title,
          description: notificationDescription,
          image: news.photoUrl,
        );

        await notificationRepository.send(notification);
      }

      showMessage(code: SetNewsCode.added, type: MessageType.toast);
      return;
    }
    else {
      showMessage(code: SetNewsCode.error);
      return;
    }
  }

  _edit(String urlImage) async {
    String description = jsonEncode(state.controller.document.toDelta().toJson());
    DateTime createdAt = state.news!.createdAt;
    DateTime date = state.news!.date;
    if (state.status == NewsStatus.pending) {
      date = state.publicationDate;
    }
    state.news = NewsItem(title: state.titleEditingController.text, createdBy: user.authId,
      date: date, photoUrl: urlImage, status: state.status, description: description,
      document: state.news!.document,);
    state.news!.createdAt = createdAt;

    bool result = await repository.update(state.news!,);

    if (result) {
      state.imagePickerResult = null;
      showMessage(code: SetNewsCode.updated, type: MessageType.toast);
      return;
    }
    else {
      showMessage(code: SetNewsCode.error);
      return;
    }
  }

}