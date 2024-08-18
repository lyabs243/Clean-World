import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/data/repositories/place_repository.dart';
import 'package:structure/data/repositories/user_repository.dart';
import 'package:structure/logic/states/places_state.dart';
import 'package:structure/utils/methods.dart';

class PlacesCubit extends Cubit<PlacesState> {

  StreamSubscription? subscription;
  final PlaceRepository repository = PlaceRepository();
  final UserRepository userRepository = UserRepository();

  PlacesCubit(super.initialState);

  initData() async {
    state.isLoading = true;
    emit(state.copy());

    Position? position = await getCurrentPosition();
    if (position != null) {
      state.currentPosition = LatLng(position.latitude, position.longitude);
    }
    state.controller?.moveCamera(CameraUpdate.newLatLng(state.currentPosition));

    state.isLoading = false;
    emit(state.copy());

    listenNearbyPlaces();
  }

  setController(GoogleMapController controller) {
    state.controller = controller;
    initData();
  }

  listenNearbyPlaces() {
    subscription?.cancel();
    GeoFirePoint center = GeoFirePoint(GeoPoint(state.currentPosition.latitude, state.currentPosition.longitude));
    double radiusInKm = 25;
    Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream = repository.getNearbyPlacesStream(
      center: center,
      radiusInKm: radiusInKm,
    );
    subscription = stream.listen((event) async {
      List<PlaceItem> places = [];

      for (DocumentSnapshot<Map<String, dynamic>> doc in event) {
        PlaceItem? item = PlaceItem.fromMap(doc.data() as Map<String, dynamic>);
        if (item != null) {
          await getUser(item.createdBy);
          item.document = doc;
          places.add(item);
        }
      }

      state.places = [... places];
      emit(state.copy());
    });
  }

  deleteItem(PlaceItem item) {
    state.places.removeWhere((element) => element.document?.id == item.document?.id);
    emit(state.copy());
  }

  addItem(PlaceItem item) async {
    state.places.insert(0, item);
    emit(state.copy());
  }

  updateItem(PlaceItem item) {
    int index = state.places.indexWhere((element) => element.document?.id == item.document?.id);

    if (index != -1) {
      state.places[index] = item;
    }

    emit(state.copy());
  }

  Future<UserItem?> getUser(String authId) async {
    UserItem? user;

    int index = state.owners.indexWhere((element) => element.authId == authId);
    if (index == -1) {
      user = await userRepository.get(authId);
      if (user != null) {
        state.owners.add(user);
      }
    } else {
      user = state.owners[index];
    }

    return user;
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

}