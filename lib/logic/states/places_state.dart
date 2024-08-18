import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/utils/my_material.dart';

class PlacesState {

  bool isLoading;
  map.GoogleMapController? controller;
  map.LatLng currentPosition;
  List<PlaceItem> places = [];
  List<UserItem> owners = [];

  PlacesState({this.isLoading = true, this.controller, required this.currentPosition,});

  PlacesState copy() {
    PlacesState copy = PlacesState(isLoading: isLoading, controller: controller, currentPosition: currentPosition,);

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

  Set<map.Marker> getMarkers(Function(PlaceItem item, UserItem? owner) onMarkerTap) {
    Set<map.Marker> markers = {};

    for (PlaceItem item in places) {
      markers.add(map.Marker(
        markerId: map.MarkerId(item.document?.id ?? ''),
        position: map.LatLng(item.latitude, item.longitude),
        onTap: () {
          onMarkerTap(item, getUser(item.createdBy));
        },
        icon: map.AssetMapBitmap(PathIcons.waste,),
      ));
    }

    return markers;
  }

}