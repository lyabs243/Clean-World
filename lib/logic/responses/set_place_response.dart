import 'package:structure/data/models/response_code_item.dart';
import 'package:structure/utils/my_material.dart';

enum SetPlaceCode {
  added,
  updated,
  error,
  errorUpload,
  fillRequiredFields,
  failedGetLocation,
  notAroundPlace,
}

class SetPlaceResponse extends ResponseCodeItem {

  final SetPlaceCode code;

  SetPlaceResponse({
    required this.code,
    super.messageType = MessageType.toast,
  });

  @override
  String message(BuildContext context) {
    switch (code) {
      case SetPlaceCode.added:
        return AppLocalizations.of(context)!.placeAdded;
      case SetPlaceCode.updated:
        return AppLocalizations.of(context)!.placeUpdated;
      case SetPlaceCode.error:
        return AppLocalizations.of(context)!.somethingWentWrong;
      case SetPlaceCode.errorUpload:
        return AppLocalizations.of(context)!.failedUploadImage;
      case SetPlaceCode.fillRequiredFields:
        return AppLocalizations.of(context)!.fillRequiredFields;
      case SetPlaceCode.failedGetLocation:
        return AppLocalizations.of(context)!.failedGetLocation;
      case SetPlaceCode.notAroundPlace:
        return AppLocalizations.of(context)!.notAroundPlace;
    }
  }

  @override
  DialogType get type {
    switch (code) {
      case SetPlaceCode.added:
      case SetPlaceCode.updated:
        return DialogType.success;
      case SetPlaceCode.fillRequiredFields:
      case SetPlaceCode.notAroundPlace:
        return DialogType.warning;
      case SetPlaceCode.error:
      case SetPlaceCode.errorUpload:
      case SetPlaceCode.failedGetLocation:
        return DialogType.error;
    }
  }
}