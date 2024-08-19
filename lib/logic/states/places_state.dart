import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/responses/places_response.dart';

class PlacesState {

  bool isLoading;
  map.GoogleMapController? controller;
  map.LatLng currentPosition;
  List<PlaceItem> places = [];
  List<UserItem> owners = [];
  PlacesResponse? response;

  PlacesState({this.isLoading = true, this.controller, required this.currentPosition, this.response});

  PlacesState copy() {
    PlacesState copy = PlacesState(isLoading: isLoading, controller: controller, currentPosition: currentPosition,
        response: response);

    copy.places = List.from(places);
    copy.owners = List.from(owners);

    return copy;
  }

  UserItem? getUser(String authId) {
    List<UserItem> items = owners.where((element) => element.authId == authId).toList();
    if (items.isNotEmpty) {
      return items.first;
    }
    return null;
  }

}