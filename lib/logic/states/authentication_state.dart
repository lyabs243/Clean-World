import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/responses/authentication_response.dart';
import 'package:structure/utils/my_material.dart';

class AuthenticationState {

  AuthenticationResponse? response;
  UserItem? user;
  AuthType? type;
  bool isLoading;

  AuthenticationState({this.response, this.isLoading = false, this.type, this.user});

  AuthenticationState copy() {
    AuthenticationState copy = AuthenticationState(response: response, isLoading: isLoading,
      type: type, user: user);

    return copy;
  }

}