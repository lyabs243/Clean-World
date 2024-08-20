import 'dart:io';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:share_plus/share_plus.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/logic/responses/set_news_response.dart';
import 'package:structure/utils/my_material.dart';

class SetNewsState {

  TextEditingController titleEditingController = TextEditingController();
  SetNewsResponse? response;
  NewsItem? news;
  NewsStatus status;
  DateTime publicationDate = DateTime.now();
  XFile? imagePickerResult;
  bool isLoading;
  QuillController controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  SetNewsState({this.news, this.response, this.isLoading = false, this.imagePickerResult,
    this.status = NewsStatus.published});

  SetNewsState copy() {
    SetNewsState copy = SetNewsState(response: response, news: news, isLoading: isLoading,
      imagePickerResult: imagePickerResult, status: status);

    copy.titleEditingController = titleEditingController;
    copy.controller = controller;
    copy.publicationDate = publicationDate;

    return copy;
  }

  ImageProvider get imageProvider {
    if (imagePickerResult != null) {
      return FileImage(File(imagePickerResult!.path));
    } else if (news != null && news!.photoUrl.isNotEmpty) {
      return NetworkImage(news!.photoUrl);
    } else {
      return AssetImage(PathImage.notFound);
    }
  }

}