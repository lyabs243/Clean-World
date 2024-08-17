import 'package:structure/data/models/notification_item.dart';
import 'package:structure/logic/responses/app_response.dart';

class AppState {

  NotificationItem? notification;
  AppResponse? response;
  bool isLoading;

  AppState({this.response, this.isLoading = true, this.notification});

  AppState copy() {
    AppState copy = AppState(response: response, isLoading: isLoading, notification: notification,);

    return copy;
  }

}