
import 'my_material.dart';

enum CustomState {
  loading,
  done,
  error,
}

enum HttpMethod {
  post,
  get,
  put,
  delete
}

enum MessageType {
  dialog,
  toast,
}

enum DialogType {error, success, info, warning}

//this one help to know if the notification must be shown inside the app or it must directly open
// the page related to the notification
enum NotificationMode {inApp, external,}

enum NotificationType {

  none(code: '1'),
  ;

  final String code;

  const NotificationType({required this.code});

  static NotificationType? getType(String code) {
    List<NotificationType> items = NotificationType.values.where((element) => element.code == code).toList();

    if (items.isNotEmpty) {
      return items.first;
    }

    return null;
  }

}

enum HomeNavigation {
  home,
  news,
  profile,
}

enum NewsWidgetAction {
  update,
  delete;

  String title(BuildContext context) {
    switch (this) {
      case NewsWidgetAction.update:
        return AppLocalizations.of(context)!.update;
      case NewsWidgetAction.delete:
        return AppLocalizations.of(context)!.delete;
    }
  }

  static List<NewsWidgetAction> getActions() {
    return [
      NewsWidgetAction.update,
      NewsWidgetAction.delete,
    ];
  }
}

enum NewsStatus {
  published,
  pending;

  String title(BuildContext context) {
    switch (this) {
      case NewsStatus.published:
        return AppLocalizations.of(context)!.published;
      case NewsStatus.pending:
        return AppLocalizations.of(context)!.pending;
    }
  }
}