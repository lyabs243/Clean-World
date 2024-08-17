import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:structure/utils/methods.dart';

const collectionUsers = 'clean_users';

const fieldUserAuthId = 'auth_id';
const fieldUserEmail = 'email';
const fieldUserName = 'name';
const fieldUserPhotoUrl = 'photo_url';
const fieldUserIsAdmin = 'is_admin';
const fieldUserCreatedAt = 'created_at';
const fieldUserDocument = 'document';

class UserItem {

  String authId, email, name, photoUrl;
  bool isAdmin;
  DateTime createdAt = DateTime.now();
  DocumentSnapshot? document;

  UserItem({required this.authId, required this.email, this.name = '', this.photoUrl = '', this.isAdmin = false, this.document,
    });

  static UserItem? fromMap(Map map, {bool isoDate = false}) {
    UserItem? user;

    try {
      if (map[fieldUserAuthId] != null && map[fieldUserEmail] != null) {
        user = UserItem(
          authId: map[fieldUserAuthId],
          email: map[fieldUserEmail],
          name: map[fieldUserName]?? '',
          photoUrl: map[fieldUserPhotoUrl]?? '',
          isAdmin: map[fieldUserIsAdmin]?? false,
          document: map[fieldUserDocument],
        );

        if (isoDate) {
          user.createdAt =  dateParsing(map[fieldUserCreatedAt]) ?? DateTime.now();
        } else {
          user.createdAt = map[fieldUserCreatedAt].toDate();
        }
      }
    }
    catch (e) {
      debugPrint('================UserItem.fromMap: $e');
    }

    return user;
  }

  Map<String, dynamic> toMap({bool isoDate = false}) {
    Map<String, dynamic> map = {
      fieldUserAuthId: authId,
      fieldUserEmail: email,
      fieldUserName: name,
      fieldUserPhotoUrl: photoUrl,
      fieldUserIsAdmin: isAdmin,
      fieldUserCreatedAt: (isoDate)
          ? createdAt.toIso8601String()
          : createdAt,
    };

    return map;
  }

}