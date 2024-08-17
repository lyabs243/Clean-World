import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/logic/responses/app_response.dart';
import 'package:structure/logic/states/app_state.dart';

import '../../utils/my_material.dart';

class AppCubit extends Cubit<AppState> {

  final SettingsRepository settingsRepository = SettingsRepository();

  AppCubit(super.initialState,) {
    initData();
  }

  void initData() async {
    state.isLoading = true;
    emit(state.copy());

    await _initCloudMessaging();

    state.isLoading = false;
    emit(state.copy());
  }

  Future _initCloudMessaging() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    SettingsItem settings = await settingsRepository.getSettings();
    if (settings.isFirstUse) {
      await FirebaseMessaging.instance.subscribeToTopic(fieldNotificationGlobalTopic);
      settings.isFirstUse = false;
      await settingsRepository.setSettings(settings);
    }

    try {
      // String? notificationToken = await FirebaseMessaging.instance.getToken();
      //debugPrint('===============Notification token: $notificationToken');
    }
    catch (e) {
      debugPrint('===============> Failed to get messaging token: $e');
    }

    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _openNotification(message,);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _openNotification(message, mode: NotificationMode.inApp);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _openNotification(message,);
    });
  }

  Future _openNotification(RemoteMessage message, {mode = NotificationMode.external}) async {
    Map<String, dynamic> data = message.data;

    NotificationType? notificationType = NotificationType.getType(data[fieldNotificationType]);
    debugPrint('=======Notification: $data == ${message.notification?.title?? ''} == $notificationType');

    if (notificationType != null) {
      state.notification = NotificationItem(type: notificationType, data: data, mode: mode,
          title: message.notification?.title?? '', description: message.notification?.body?? '',
          image: data[fieldNotificationImage]?? '',);
    }

    emit(state.copy());
  }

  showMessage({AppCode? code, MessageType type = MessageType.toast}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (code != null) {
      state.response = AppResponse(code: code, messageType: type);
    }

    state.isLoading = false;
    emit(state.copy());
  }

  // Simple test which display a success dialog
  testShowDialog() async {
    await Future.delayed(const Duration(milliseconds: 700));
    showMessage(code: AppCode.success, type: MessageType.dialog);
  }

}