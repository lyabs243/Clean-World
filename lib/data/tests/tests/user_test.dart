import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/repositories/user_repository.dart';
import 'package:structure/utils/my_material.dart';
import 'package:test/test.dart' as test;

class UserTest {

  static UserItem user = UserItem(
    name: 'Mr Jones',
    authId: 'hjhjjkj',
    email: 'loicyabili@outlook.com',
    photoUrl: '',
  );

  static UserRepository repository = UserRepository();

  static run() {
    debugPrint('=========Start User\'s Tests=========');

    _add();
    _update();
    _getUser();
    _getFromEmail();
    _getCurrentUser();
    _updateField();
    _updateProfile();
    _getItems();
  }

  static _add() {
    test.test('Add user', () async {
      DocumentSnapshot? document = await repository.add(user);
      user.document = document;
      test.expect(document, test.isNot(null));
    });
  }

  static _update() {
    test.test('Update user', () async {
      user.name = 'Mr Jones 2';
      bool res = await repository.updateProfile(user,);
      test.expect(res, true);
    });
  }

  static _getUser() {
    test.test('Get user', () async {
      UserItem? user = await repository.get(UserTest.user.authId);
      test.expect(user, test.isNot(null));
    });
  }

  static _getFromEmail() {
    test.test('Get user from email', () async {
      UserItem? user = await repository.getFromEmail(UserTest.user.email);

      if (user != null) {
        UserTest.user = user;
      }
      test.expect(user, test.isNot(null));
    });
  }

  static _getCurrentUser(){
    test.test('Get user current ', ()async{
      await repository.setCurrentUser(UserTest.user);

      UserItem? user = await repository.getCurrentUser();
      if(user != null){
        UserTest.user = user;
      }

      test.expect(user, test.isNot(null));
    });
  }

  static _updateField() {
    test.test('Update user field', () async {
      bool res = await repository.updateField(fieldUserName, 'New value', user,);
      test.expect(res, true);
    });
  }

  static _updateProfile() {
    test.test('Update user profile', () async {
      user.name = 'Mr Jones 3';
      bool res = await repository.updateProfile(user,);
      test.expect(res, true);
    });
  }

  static _getItems() {
    test.test('Get user items', () async {
      List<UserItem> users = await repository.getItems();
      test.expect(users, test.isNotEmpty);
    });
  }

}