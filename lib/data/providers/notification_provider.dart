import 'package:cloud_functions/cloud_functions.dart';
import '../../utils/my_material.dart';

class NotificationProvider {

  NotificationProvider();

  Future<HttpsCallableResult?> send({required String title, required String message, required String type,
    Map<String, String> arguments = const {}, String? image,}) async {

    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(functionSendNotification);
      Map mapArguments = {
        'title': title,
        'description': message,
        'data': arguments,
        'type': type,
      };

      if (image != null) {
        mapArguments['image'] = image;
      }

      final response = await callable.call(mapArguments);
      debugPrint('===$mapArguments=======Notification sent: ${response.data}');
      return response;
    }
    catch (err) {
      debugPrint('=========Failed to send notification $err');
    }

    return null;

  }

}