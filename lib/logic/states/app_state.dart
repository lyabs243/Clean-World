import 'package:geolocator/geolocator.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/responses/app_response.dart';
import 'package:structure/utils/enums.dart';

class AppState {

  NotificationItem? notification;
  AppResponse? response;
  Position? devicePosition;
  UserItem? user;
  bool isLoading;

  AppState({this.response, this.isLoading = true, this.notification, this.user, this.devicePosition});

  AppState copy() {
    AppState copy = AppState(response: response, isLoading: isLoading, notification: notification,
      user: user, devicePosition: devicePosition);

    return copy;
  }

  bool get isConnected {
    return user != null && user!.authType != AuthType.guest;
  }

}