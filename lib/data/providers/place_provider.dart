import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:structure/data/models/place_item.dart';

class PlaceProvider {

  DocumentReference queryGetItem(String storyId) {
    return FirebaseFirestore.instance
      .collection(collectionPlaces)
      .doc(storyId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? city, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) {
    Query query = FirebaseFirestore.instance
      .collection(collectionPlaces);

    if (createdBy != null) {
      query = query.where(fieldPlaceCreatedBy, isEqualTo: createdBy);
    }

    if (city != null) {
      query = query.where(fieldPlaceCity, isEqualTo: city);
    }

    if (startDate != null) {
      query = query.where(fieldPlaceCreatedAt, isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where(fieldPlaceCreatedAt, isLessThanOrEqualTo: endDate);
    }

    if (descending != null) {
      query = query.orderBy(fieldPlaceCreatedAt, descending: descending);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query;
  }

  Future<DocumentSnapshot?> add(Map<String, dynamic> map) async {
    DocumentSnapshot? document;

    try {
      document = await FirebaseFirestore.instance
        .collection(collectionPlaces)
        .add(map)
        .then((value) => value.get());
    } catch (e) {
      debugPrint('=========Failed to add place: $e');
    }

    return document;
  }

  Future<List<Map>> getItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? city, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) async {
    List<Map> list = [];

    try {
      var result = await queryGetItems(startAfter: startAfter, limit: limit, city: city,
        startDate: startDate, endDate: endDate, descending: descending, createdBy: createdBy,).get();
      if (result.docs.isNotEmpty) {
        for (DocumentSnapshot document in result.docs) {
          Map map = document.data() as Map;
          map[fieldPlaceDocument] = document;
          list.add(map);
        }
      }
    } catch (e) {
      debugPrint('=========Failed to get places: $e');
    }

    return list;
  }

  Future<Map> get(String documentId) async {
    Map map = {};

    try {
      var result = await FirebaseFirestore.instance
        .collection(collectionPlaces)
        .doc(documentId)
        .get();
      map = result.data() as Map;
      map[fieldPlaceDocument] = result;
    } catch (e) {
      debugPrint('=========Failed to get place: $e');
    }

    return map;
  }

  Future<bool> update(String documentId, Map<String, dynamic> map) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance
        .collection(collectionPlaces)
        .doc(documentId)
        .update(map);
      success = true;
    } catch (e) {
      debugPrint('=========Failed to update place: $e');
    }

    return success;
  }

  Future<bool> delete(String documentId) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance
        .collection(collectionPlaces)
        .doc(documentId)
        .delete();
      success = true;
    } catch (e) {
      debugPrint('=========Failed to delete place: $e');
    }

    return success;
  }

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getNearbyPlacesStream({
    required GeoFirePoint center,
    required double radiusInKm,
  }) {
    return GeoCollectionReference<Map<String, dynamic>>(
      FirebaseFirestore.instance.collection(collectionPlaces)
    ).subscribeWithin(
      center: center,
      radiusInKm: radiusInKm,
      field: fieldPlacePosition,
      geopointFrom: (Map<String, dynamic> data) => (data[fieldPlacePosition] as Map<String, dynamic>)['geopoint'] as GeoPoint,
    );
  }
}