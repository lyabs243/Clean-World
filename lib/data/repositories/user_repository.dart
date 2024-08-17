import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/providers/user_provider.dart';
import '../../utils/my_material.dart';

class UserRepository {

  final UserProvider provider = UserProvider();

  static DocumentReference queryGetUser(String docId,) {
    return UserProvider.queryGetUser(docId);
  }

  Future<DocumentSnapshot?> add(UserItem user) async {
    return await provider.add(user.authId, user.toMap());
  }

  Future<bool> update(UserItem user,) async {
    return await provider.update(user.toMap(), user.authId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? isAdmin}) {
    return provider.queryGetItems(startAfter: startAfter, limit: limit, isAdmin: isAdmin);
  }

  Future<UserItem?> get(String docId) async {
    Map map = await provider.get(docId);
    return UserItem.fromMap(map);
  }

  Future<bool> updateField(String field, dynamic value, UserItem user) async {
    return await provider.update({field: value}, user.authId);
  }

  Future<bool> updateProfile(UserItem user,)async{

    Map<String, dynamic> map = {
      fieldUserPhotoUrl: user.photoUrl,
      fieldUserEmail: user.email,
      fieldUserName: user.name,
    };

    return await provider.update(map, user.authId);
  }

  Future<UserItem?> getFromEmail(String email) async {
    Map map = await provider.getFromEmail(email);
    return UserItem.fromMap(map);
  }

  Future<List<UserItem>> getItems({DocumentSnapshot? startAfter, int? limit, bool? isAdmin}) async {
    List<Map> list = await provider.getItems(startAfter: startAfter, limit: limit, isAdmin: isAdmin);

    List<UserItem> users = [];

    for (Map map in list) {
      UserItem? user = UserItem.fromMap(map);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  Future setCurrentUser(UserItem? userItem) async {

    Map<String, dynamic> map = {};
    if (userItem != null) {
      map = userItem.toMap(isoDate: true);
    }

    await provider.setCurrentUser(map);
  }

  Future<UserItem?> getCurrentUser() async{
    UserItem? user;

    Map<String, dynamic> map = await provider.getCurrentUser();
    try{
      user = UserItem.fromMap(map, isoDate: true);
    } catch(err) {
      debugPrint('==============Failed to get current user: $err');
    }
    return user;
  }

}