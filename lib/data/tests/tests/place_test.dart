import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/repositories/place_repository.dart';
import 'package:test/test.dart' as test;
import '../../../utils/my_material.dart';

class PlaceTest {

  static final PlaceRepository repository = PlaceRepository();
  static PlaceItem? item;

  static void run() async {
    debugPrint('==========Start Place tests');

    add();
    getAll();
    get();
    getNearbyPlaces();
    update();
    updatePhotosUrls();
    delete();
  }

  static void add() {
    test.test('Add Place', () async {
      PlaceItem itemPlace = PlaceItem(
        createdBy: '1',
        description: 'Description',
        latitude: 37.42008022143011,
        longitude: -122.08811201155186
      );
      DocumentSnapshot? doc = await repository.add(itemPlace);
      itemPlace.document = doc;
      item = itemPlace;
      test.expect(doc, test.isNot(null));
    });
  }

  static void getAll(){
    test.test('Get places', () async {
      List<PlaceItem> items = await repository.getItems();
      test.expect(items, test.isNotEmpty);
    });
  }

  static void getNearbyPlaces(){
    Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream = repository.getNearbyPlacesStream(
      center: const GeoFirePoint(GeoPoint(37.42796133580664, -122.085749655962)),
      radiusInKm: 10,
    );
    stream.listen((event) {
      debugPrint('==========> Nearby places: ${event.length}');
    });
  }

  static void get(){
    test.test('Get place', () async {
      PlaceItem? itemPlace = await repository.get("${item?.document?.id}");
      test.expect(itemPlace, test.isNot(null));
    });
  }

  static void update(){
    test.test('Update place', () async {
      item!.description = 'Description updated';
      bool res = await repository.update(item!);
      test.expect(res, true);
    });
  }

  static void updatePhotosUrls(){
    test.test('Update photos urls', () async {
      bool res = await repository.updatePhotosUrls(item!, ['url1', 'url2']);
      test.expect(res, true);
    });
  }

  static void delete(){
    test.test('Delete place', () async {
      bool res = await repository.delete(item!);
      test.expect(res, true);
    });
  }

}