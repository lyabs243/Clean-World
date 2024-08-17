import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/providers/place_provider.dart';

class PlaceRepository {

  final PlaceProvider provider = PlaceProvider();

  DocumentReference queryGetItem(String placeId) {
    return provider.queryGetItem(placeId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? city, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) {
    return provider.queryGetItems(
      startAfter: startAfter,
      limit: limit,
      descending: descending,
      city: city,
      createdBy: createdBy,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<DocumentSnapshot?> add(PlaceItem place) async {
    return await provider.add(place.toMap());
  }

  Future<List<PlaceItem>> getItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? city, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) async {
    List<Map> list = await provider.getItems(
      startAfter: startAfter,
      limit: limit,
      descending: descending,
      city: city,
      createdBy: createdBy,
      startDate: startDate,
      endDate: endDate,
    );

    List<PlaceItem> places = [];

    for (Map map in list) {
      PlaceItem? place = PlaceItem.fromMap(map);
      if (place != null) {
        places.add(place);
      }
    }

    return places;
  }

  Future<PlaceItem?> get(String placeId) async {
    Map map = await provider.get(placeId);
    return PlaceItem.fromMap(map);
  }

  Future<bool> update(PlaceItem place) async {
    if (place.document == null) {
      return false;
    }
    return await provider.update(place.document!.id, place.toMap(),);
  }

  Future<bool> updatePhotosUrls(PlaceItem place, List<String> photosUrls) async {
    if (place.document == null) {
      return false;
    }

    return await provider.update(place.document!.id, {fieldPlacePhotosUrls: photosUrls});
  }

  Future<bool> delete(PlaceItem place) async {
    if (place.document == null) {
      return false;
    }
    return await provider.delete(place.document!.id);
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getNearbyPlacesStream({
    required GeoFirePoint center,
    required double radiusInKm,
  }) {
    return provider.getNearbyPlacesStream(center: center, radiusInKm: radiusInKm);
  }

}