import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:structure/data/models/user_item.dart';
import '../../utils/my_material.dart';

class UserProvider {
  static DocumentReference queryGetUser(String docId,) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(docId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? isAdmin}) {

    Query query = FirebaseFirestore.instance
        .collection(collectionUsers);

    if (isAdmin != null) {
      query = query.where(fieldUserIsAdmin, isEqualTo: isAdmin);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query;
  }

  Future<DocumentSnapshot?> add(String authId, Map<String, dynamic> mapUser) async {
    DocumentSnapshot? document;

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(collectionUsers)
          .doc(authId);
      await documentReference.set(mapUser);
      document = await documentReference.get();
    } catch (err) {
      debugPrint('==========Failed to add user: $err');
    }
    return document;
  }

  Future<bool> update(Map<String, dynamic> mapUser, String docId) async {
    bool hasUpdate = false;

    try {
     await FirebaseFirestore.instance
          .collection(collectionUsers)
          .doc(docId)
          .update(mapUser);
      hasUpdate = true;
    } catch (err) {
      debugPrint('==========Failed to update user: $err');
    }
    return hasUpdate;
  }

  Future<Map> get(String documentId) async {
    Map map = {};

    try {
      var result = await FirebaseFirestore.instance
          .collection(collectionUsers)
          .doc(documentId)
          .get();
      if (result.data() != null) {
        map = result.data()!;
        map[fieldUserDocument] = result;
      }
    } catch (err) {
      debugPrint('=======Failed to get user:$err');
    }
    return map;
  }

  Future<List<Map>> getItems({DocumentSnapshot? startAfter, int? limit, bool? isAdmin}) async {
    List<Map> list = [];

    try {
      Query query = queryGetItems(startAfter: startAfter, limit: limit, isAdmin: isAdmin);
      QuerySnapshot querySnapshot = await query.get();
      for (var result in querySnapshot.docs) {
        Map map = result.data() as Map;
        map[fieldUserDocument] = result;
        list.add(map);
      }
    } catch (err) {
      debugPrint('=======Failed to get users:$err');
    }
    return list;
  }

  Future<Map> getFromEmail(String email) async {
    Map map = {};

    try {
      var result = await FirebaseFirestore.instance
          .collection(collectionUsers)
          .where(fieldUserEmail, isEqualTo: email)
          .get();
      if (result.docs.isNotEmpty) {
        map = result.docs.first.data();
        map[fieldUserDocument] = result.docs.first;
      }
    } catch (err) {
      debugPrint('=======Failed to get user from email:$err');
    }
    return map;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    Map<String, dynamic> result = {};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(prefCurrentUser);
    //debugPrint('======User=JSON====$userString');
    if (userString != null) {
      try {
        result = json.decode(userString);
      } catch (err) {
        debugPrint("============Failed to get current user: $err");
      }
    }
    return result;
  }

  Future setCurrentUser(Map<String, dynamic> map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefCurrentUser, json.encode(map));
  }

}