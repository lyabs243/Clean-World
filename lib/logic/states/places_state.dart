import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/utils/path_assets.dart';

class PlacesState {

  bool isLoading;
  GoogleMapController? controller;
  LatLng currentPosition;
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

  Set<Marker> getMarkers(Function(PlaceItem item) onMarkerTap) {
    Set<Marker> markers = {};

    for (PlaceItem item in places) {
      markers.add(Marker(
        markerId: MarkerId(item.document?.id ?? ''),
        position: LatLng(item.latitude, item.longitude),
        onTap: () {
          onMarkerTap(item);
        },
        icon: AssetMapBitmap(PathIcons.waste,),
      ));
    }

    return markers;
  }

}