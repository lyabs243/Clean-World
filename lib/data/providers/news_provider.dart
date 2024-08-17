import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:structure/data/models/news_item.dart';

class NewsProvider {

  DocumentReference queryGetItem(String storyId) {
    return FirebaseFirestore.instance
      .collection(collectionNews)
      .doc(storyId);
  }

  Query queryGetItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? status, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) {
    Query query = FirebaseFirestore.instance
      .collection(collectionNews);

    if (createdBy != null) {
      query = query.where(fieldNewsCreatedBy, isEqualTo: createdBy);
    }

    if (status != null) {
      query = query.where(fieldNewsStatus, isEqualTo: status);
    }

    if (startDate != null) {
      query = query.where(fieldNewsDate, isGreaterThanOrEqualTo: startDate);
    }

    if (endDate != null) {
      query = query.where(fieldNewsDate, isLessThanOrEqualTo: endDate);
    }

    if (descending != null) {
      query = query.orderBy(fieldNewsDate, descending: descending);
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
        .collection(collectionNews)
        .add(map)
        .then((value) => value.get());
    } catch (e) {
      debugPrint('=========Failed to add news: $e');
    }

    return document;
  }

  Future<List<Map>> getItems({DocumentSnapshot? startAfter, int? limit, bool? descending, String? status, String? createdBy,
    DateTime? startDate, DateTime? endDate,}) async {
    List<Map> list = [];

    try {
      var result = await queryGetItems(startAfter: startAfter, limit: limit, status: status,
        startDate: startDate, endDate: endDate, descending: descending, createdBy: createdBy,).get();
      if (result.docs.isNotEmpty) {
        for (DocumentSnapshot document in result.docs) {
          Map map = document.data() as Map;
          map[fieldNewsDocument] = document;
          list.add(map);
        }
      }
    } catch (e) {
      debugPrint('=========Failed to get news: $e');
    }

    return list;
  }

  Future<Map> get(String documentId) async {
    Map map = {};

    try {
      var result = await FirebaseFirestore.instance
        .collection(collectionNews)
        .doc(documentId)
        .get();
      map = result.data() as Map;
      map[fieldNewsDocument] = result;
    } catch (e) {
      debugPrint('=========Failed to get single news: $e');
    }

    return map;
  }

  Future<bool> update(String documentId, Map<String, dynamic> map) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance
        .collection(collectionNews)
        .doc(documentId)
        .update(map);
      success = true;
    } catch (e) {
      debugPrint('=========Failed to update news: $e');
    }

    return success;
  }

  Future<bool> delete(String documentId) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance
        .collection(collectionNews)
        .doc(documentId)
        .delete();
      success = true;
    } catch (e) {
      debugPrint('=========Failed to delete news: $e');
    }

    return success;
  }
}