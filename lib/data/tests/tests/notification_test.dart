import 'package:structure/data/models/notification_item.dart';
import 'package:structure/data/repositories/notification_repository.dart';
import '../../../utils/my_material.dart';
import 'package:test/test.dart' as test;

class NotificationTest {

  static NotificationRepository repository = NotificationRepository();

  static run() async {
    debugPrint('==========Start Notification tests');

    _sendNotification();
  }

  static _sendNotification() {

    test.test('Send notification', () async {

      NotificationItem notification = NotificationItem(
        type: NotificationType.news,
        data: {'news_id': 'sfkjsfksfks', 'type': NotificationType.news.code},
        title: 'Une journée spéciale pour vous',
        description: 'Découvrez notre nouvelle animation pour votre événement avec des surprises et des cadeaux à gagner.'
            'Cliquez sur le lien pour en savoir plus. Jusqu\'au 31 décembre 2021. Ne ratez pas cette occasion.'
            'Cliquez sur le lien pour en savoir plus. Jusqu\'au 31 décembre 2021. Ne ratez pas cette occasion.',
        image: 'https://picsum.photos/200/300',
      );

      String? res = await repository.send(notification);
      test.expect(res, test.isNot(null));
    });
  }

}