import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/utils/methods.dart';
import 'package:structure/utils/my_material.dart';

const collectionNotification = 'clean_notifications';

const fieldNotificationDocument = 'document';
const fieldNotificationTitle = 'title';
const fieldNotificationDescription = 'description';
const fieldNotificationImage = 'image';
const fieldNotificationData = 'data';
const fieldNotificationType = 'type';
const fieldNotificationCreationDate = 'creation_date';

class NotificationItem {

  NotificationType type;
  NotificationMode mode;
  String title, description, image;
  Map<String, dynamic> data;
  DateTime creationDate = DateTime.now();

  DocumentSnapshot? document;

  NotificationItem({required this.type, this.mode = NotificationMode.external, this.title = '', this.description = '', required this.data,
    this.document, this.image = '',});

  static NotificationItem? fromMap(Map map, {isoDate = false}) {
    NotificationItem? item;

    if (map[fieldNotificationType] != null && map[fieldNotificationData] != null) {

      item = NotificationItem(type: NotificationType.getType(map[fieldNotificationType])?? NotificationType.none,
        data: map[fieldNotificationData]?? {}, document: map[fieldNotificationDocument],
        title: map[fieldNotificationTitle]?? '', description: map[fieldNotificationDescription]?? '', image: map[fieldNotificationImage]?? '',
        );

      if (isoDate) {
        item.creationDate = dateParsing(map[fieldNotificationCreationDate]) ?? DateTime.now();
      }
      else {
        item.creationDate = map[fieldNotificationCreationDate].toDate();
      }

    }
    return item;
  }

  Map<String, dynamic> toMap({isoDate = false}) {
    return {
      fieldNotificationTitle: title,
      fieldNotificationDescription: description,
      fieldNotificationType: type.code,
      fieldNotificationData: data,
      fieldNotificationImage: image,
      fieldNotificationCreationDate: (isoDate)? creationDate.toIso8601String():creationDate,
    };
  }

  Map<String, String> get dataString {
    Map<String, String> map = {};

    data.forEach((key, value) {
      map[key] = value.toString();
    });

    return map;
  }

  //check if it is same day as another notification
  bool isSameDay(NotificationItem item) {
    DateTime now = DateTime.now();
    DateTime date = creationDate;
    DateTime date2 = item.creationDate;

    if (now.year == date.year && now.month == date.month && now.day == date.day &&
        now.year == date2.year && now.month == date2.month && now.day == date2.day) {
      return true;
    }
    else {
      return false;
    }
  }

  NotificationItem copy() {
    NotificationItem copy = NotificationItem(type: type, mode: mode, title: title, description: description, data: data,
      document: document, image: image,);
    copy.creationDate = creationDate;
    return copy;
  }

  @override
  bool operator ==(Object other) => other is NotificationItem && document?.id == other.document?.id;

  @override
  int get hashCode => document?.id.hashCode ?? 0;

  String get page {
    switch (type) {
      case NotificationType.news:
        return pageNewsDetails;
      case NotificationType.none:
        return pageHome;
    }
  }

  Map<String, dynamic> get arguments {
    switch (type) {
      case NotificationType.news:
        return {
          argumentDocumentId: data['news_id'],
          argumentNews: NewsItem(
            title: title,
            createdBy: '',
            date: DateTime.now(),
          ),
        };
      case NotificationType.none:
        return {};
    }
  }

}