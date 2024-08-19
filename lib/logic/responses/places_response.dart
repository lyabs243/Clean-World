import 'package:structure/data/models/response_code_item.dart';
import 'package:structure/utils/my_material.dart';

enum PlacesCode {success, error, operationInProgress}

class PlacesResponse extends ResponseCodeItem {

  PlacesCode code;

  PlacesResponse({required this.code, super.messageType = MessageType.toast});

  @override
  String message(BuildContext context) {
    switch (code) {
      case PlacesCode.success:
        return AppLocalizations.of(context)!.success;
      case PlacesCode.error:
        return AppLocalizations.of(context)!.somethingWentWrong;
      case PlacesCode.operationInProgress:
        return '${AppLocalizations.of(context)!.operationInProgress}...';
    }
  }

  @override
  DialogType get type {
    switch (code) {
      case PlacesCode.success:
        return DialogType.success;
      case PlacesCode.error:
        return DialogType.error;
      case PlacesCode.operationInProgress:
        return DialogType.info;
    }
  }

}