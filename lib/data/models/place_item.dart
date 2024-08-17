import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

const collectionPlaces = "clean_places";

const fieldPlaceDescription = "description";
const fieldPlaceLatitude = "latitude";
const fieldPlaceLongitude = "longitude";
const fieldPlacePosition = "position";
const fieldPlaceCity = "city";
const fieldPlacePhotosUrls = "photos_urls";
const fieldPlaceCreatedBy = "created_by";
const fieldPlaceCreatedAt = "created_at";
const fieldPlaceDocument = "document";

class PlaceItem {

  String description, city, createdBy;
  double latitude, longitude;
  DateTime createdAt = DateTime.now();
  List<String> photosUrls = [];
  DocumentSnapshot? document;

  PlaceItem({
    required this.description,
    required this.createdBy,
    required this.latitude,
    required this.longitude,
    this.city = '',
    this.document,
  });

  static PlaceItem? fromMap(Map map) {
    PlaceItem? item;

    if (map[fieldPlaceDescription] != null && map[fieldPlaceCreatedBy] != null && map[fieldPlaceLatitude] != null && map[fieldPlaceLongitude] != null) {
      item = PlaceItem(
        description: map[fieldPlaceDescription],
        createdBy: map[fieldPlaceCreatedBy],
        latitude: map[fieldPlaceLatitude],
        longitude: map[fieldPlaceLongitude],
        city: map[fieldPlaceCity]?? '',
        document: map[fieldPlaceDocument],
      );

      if (map[fieldPlacePhotosUrls] != null && map[fieldPlacePhotosUrls] is List) {
        item.photosUrls = [];
        for (String speechUrl in map[fieldPlacePhotosUrls]) {
          item.photosUrls.add(speechUrl);
        }
      }

      if (map[fieldPlaceCreatedAt] != null) {
        item.createdAt = map[fieldPlaceCreatedAt].toDate();
      }
    }

    return item;
  }

  Map<String, dynamic> toMap() {
    return {
      fieldPlaceDescription: description,
      fieldPlaceCreatedBy: createdBy,
      fieldPlaceLatitude: latitude,
      fieldPlaceLongitude: longitude,
      fieldPlaceCity: city,
      fieldPlacePhotosUrls: photosUrls,
      fieldPlaceCreatedAt: createdAt,
      fieldPlacePosition: GeoFirePoint(GeoPoint(latitude, longitude)).data,
    };
  }

}