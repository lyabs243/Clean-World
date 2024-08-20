import 'package:structure/data/models/response_code_item.dart';
import 'package:structure/utils/my_material.dart';

enum SetNewsCode {
  added,
  updated,
  error,
  errorUpload,
  fillRequiredFields,
}

class SetNewsResponse extends ResponseCodeItem {

  final SetNewsCode code;

  SetNewsResponse({
    required this.code,
    super.messageType = MessageType.toast,
  });

  @override
  String message(BuildContext context) {
    switch (code) {
      case SetNewsCode.added:
        return AppLocalizations.of(context)!.newsAdded;
      case SetNewsCode.updated:
        return AppLocalizations.of(context)!.newsUpdated;
      case SetNewsCode.error:
        return AppLocalizations.of(context)!.somethingWentWrong;
      case SetNewsCode.errorUpload:
        return AppLocalizations.of(context)!.failedUploadImage;
      case SetNewsCode.fillRequiredFields:
        return AppLocalizations.of(context)!.fillRequiredFields;
    }
  }

  @override
  DialogType get type {
    switch (code) {
      case SetNewsCode.added:
      case SetNewsCode.updated:
        return DialogType.success;
      case SetNewsCode.fillRequiredFields:
        return DialogType.warning;
      case SetNewsCode.error:
      case SetNewsCode.errorUpload:
        return DialogType.error;
    }
  }
}