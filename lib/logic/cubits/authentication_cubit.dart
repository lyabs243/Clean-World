import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/repositories/user_repository.dart';
import 'package:structure/logic/responses/authentication_response.dart';
import 'package:structure/logic/states/authentication_state.dart';
import 'package:structure/utils/my_material.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {

  final UserRepository repository = UserRepository();

  AuthenticationCubit(super.initialState);

  signInWithGoogle() async {
    state.type = AuthType.google;
    state.isLoading = true;
    emit(state.copy());

    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }
      await finalizeAuthentication(userCredential);

    } catch (e) {
      debugPrint('================Error signInWithGoogle: $e');
      showMessage(code: AuthenticationCode.authFailed);
    }
  }

  signInAsGuest() async {
    state.type = AuthType.guest;
    state.isLoading = true;
    emit(state.copy());

    try {
      await finalizeAuthentication(null);
    } catch (e) {
      debugPrint('================Error signInAsGuest: $e');
      showMessage(code: AuthenticationCode.authFailed);
    }
  }

  Future finalizeAuthentication(UserCredential? userCredential) async {
    try {
      UserItem? userItem;
      if (userCredential != null && state.type != AuthType.guest) {
        User? user = userCredential.user;

        if (user == null) {
          showMessage(code: AuthenticationCode.authFailed);
          return;
        }

        String email = (user.email?.isNotEmpty?? false)? user.email!: 'anonymous-${user.uid}@lyabs.dev';
        String name = (user.email?.isNotEmpty?? false)? user.displayName!: 'Anonymous';
        String photo = user.photoURL?? '';
        String authId = user.uid;

        userItem = await repository.getFromEmail(email);
        if (userItem == null) {
          userItem = UserItem(email: email, name: name, photoUrl: photo, authId: authId,
              authType: state.type!);
          DocumentSnapshot? document = await repository.add(userItem);
          if (document == null) {
            showMessage(code: AuthenticationCode.authFailed);
            return;
          }
        } else {
          userItem.authId = authId;
          userItem.photoUrl = photo;
          userItem.name = name;
          await repository.update(userItem);
        }
      } else {
        userItem = UserItem(email: 'anonymous-${DateTime.now().millisecondsSinceEpoch}@lyabs.dev', name: 'Anonymous',
            authId: 'anonymous-${DateTime.now().millisecondsSinceEpoch}', authType: state.type!);
      }

      state.user = userItem;
      showMessage(code: AuthenticationCode.success);
    } catch (e) {
      debugPrint('================Error finalizeAuthentication: $e');
      showMessage(code: AuthenticationCode.authFailed);
    }
  }

  showMessage({AuthenticationCode? code, MessageType type = MessageType.dialog}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (code != null) {
      state.response = AuthenticationResponse(code: code, messageType: type);
    }

    state.isLoading = false;
    state.type = null;
    emit(state.copy());
  }

}