
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/logic/cubits/news_cubit.dart';

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
  news(code: '2'),
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

  onTap(BuildContext context, NewsItem news) {
    switch (this) {
      case NewsWidgetAction.update:
        Navigator.of(context).pushNamed(
          pageSetNews,
          arguments: {
            argumentEdit: true,
            argumentNews: news,
          }
        );
        break;
      case NewsWidgetAction.delete:
        AppDialog.showConfirmDialog(
            context,
            AppLocalizations.of(context)!.wantDeleteNews,
        ).then((val) {
          if (val) {
            context.read<NewsCubit>().delete();
          }
        });
        break;
    }
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

  static NewsStatus? fromString(String value) {
    switch (value) {
      case 'published':
        return NewsStatus.published;
      case 'pending':
        return NewsStatus.pending;
      default:
        return null;
    }
  }
}

enum AuthType {
  google,
  guest;

  static AuthType? fromString(String value) {
    switch (value) {
      case 'google':
        return AuthType.google;
      case 'guest':
        return AuthType.guest;
      default:
        return null;
    }
  }
}