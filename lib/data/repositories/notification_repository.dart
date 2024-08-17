import 'package:cloud_functions/cloud_functions.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/data/providers/notification_provider.dart';

class NotificationRepository {

  final NotificationProvider provider = NotificationProvider();

  //return the notification id
  Future<String?> send(NotificationItem notification) async {

    HttpsCallableResult? response = await provider.send(title: notification.title, message: notification.description, arguments: notification.dataString,
      image: notification.image, type: notification.type.code,);

    if (response?.data != null && response!.data['id'] is String) {
      return response.data['id'];
    }

    return null;
  }

}