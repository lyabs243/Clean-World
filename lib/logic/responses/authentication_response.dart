import 'package:structure/data/models/response_code_item.dart';
import 'package:structure/utils/my_material.dart';

enum AuthenticationCode {authFailed, success}

class AuthenticationResponse extends ResponseCodeItem {

  AuthenticationCode code;

  AuthenticationResponse({required this.code, super.messageType = MessageType.toast});

  @override
  String message(BuildContext context) {
    switch (code) {
      case AuthenticationCode.authFailed:
        return AppLocalizations.of(context)!.authenticationFailed;
      case AuthenticationCode.success:
        return AppLocalizations.of(context)!.success;
    }
  }

  @override
  DialogType get type {
    switch (code) {
      case AuthenticationCode.authFailed:
        return DialogType.error;
      case AuthenticationCode.success:
        return DialogType.success;
    }
  }

}