import 'package:overlay_support/overlay_support.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/utils/methods.dart';
import 'package:structure/utils/my_material.dart';

class LocalNotificationWidget extends StatelessWidget {

  final NotificationItem notification;

  const LocalNotificationWidget({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('in-app-notification'),
      confirmDismiss: (direction) async {
        OverlaySupportEntry.of(context)!.dismiss();
        return true;
      },
      onDismissed: (direction) {
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(
                  child: (notification.image.isNotEmpty)?
                  Image.network(notification.image, fit: BoxFit.cover):
                  const Icon(Icons.notifications)
                )
            ),
            title: Text(
              notification.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              notification.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () {
                OverlaySupportEntry.of(context)!.dismiss();
                openPage(context, notification.page, notification.arguments);
              },
              child: Text(
                AppLocalizations.of(context)!.view.toUpperCase(),
              ),
            ),
          ),
        ),
      ),
    );
  }

}