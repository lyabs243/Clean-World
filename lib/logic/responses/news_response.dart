import 'package:structure/data/models/response_code_item.dart';
import 'package:structure/utils/my_material.dart';

enum NewsCode {error, deleted}

class NewsResponse extends ResponseCodeItem {

  final NewsCode code;

  NewsResponse({super.messageType = MessageType.toast, required this.code});

  @override
  String message(BuildContext context) {
    switch (code) {
      case NewsCode.error:
        return AppLocalizations.of(context)!.errorOccurred;
      case NewsCode.deleted:
        return AppLocalizations.of(context)!.newsDeleted;
    }
  }

  @override
  DialogType get type {
    switch (code) {
      case NewsCode.error:
        return DialogType.error;
      case NewsCode.deleted:
        return DialogType.success;
    }
  }

}