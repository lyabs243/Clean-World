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

      // Initialize some places
      // PlaceItem p1 = PlaceItem(
      //   createdBy: 'LpdaBBxDKvTsSHP779HeGHqVK042',
      //   description: "Des déchets tels que des papiers, des gobelets en plastique et des mégots de cigarettes s'accumulent dans les coins du parking du centre commercial. Cette accumulation est probablement due à l'absence de poubelles dans la zone. Si elle n'est pas traitée, elle pourrait créer un environnement insalubre pour les visiteurs et contribuer à la pollution des environs.",
      //   latitude: -11.6619401,
      //   longitude: 27.4499537,
      // );
      // p1.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2F142934D5-4942-4F2A-9F1E-079746365EC9.jpeg?alt=media&token=4190bfb6-621c-4f37-9c88-e33060917d7d',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2F618a5b90-9e0f-11e9-9f79-0e7266730414.jpg?alt=media&token=7328c2ac-7fc8-41e7-9fd6-58c2f19ce818',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FDSC_0205.JPG?alt=media&token=4bf509c0-f91a-4f9c-9472-5cad98bdd6ca',
      // ];
      //
      // PlaceItem p2 = PlaceItem(
      //   createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //   description: "De nombreux détritus, notamment des canettes, des bouteilles en plastique et des emballages de nourriture, ont été laissés sur la plage après un week-end de forte affluence. Les déchets sont dispersés par le vent et les vagues, menaçant les animaux marins et dégradant la beauté naturelle du site. Une action rapide est nécessaire pour éviter une pollution plus grave.",
      //   latitude: -11.654711,
      //   longitude: 27.454074,
      // );
      // p2.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FD%C3%A9chets%20(c)De%20vchal%20shutterstock_597557036%20(1).jpg?alt=media&token=71324d2b-4a76-499f-8e23-3d7f6227c418',
      // ];
      //
      // PlaceItem p3 = PlaceItem(
      //   createdBy: 'LpdaBBxDKvTsSHP779HeGHqVK042',
      //   description: "Un tas de déchets illégaux, comprenant des appareils électroménagers cassés et des sacs de béton, a été trouvé dans une zone isolée de la forêt urbaine. Les déchets sont cachés sous des broussailles, ce qui les rend difficiles à repérer. Cette décharge clandestine pourrait nuire à la flore locale et contribuer à la dégradation de cet espace naturel.",
      //   latitude: -11.656380,
      //   longitude: 27.471321,
      // );
      // p3.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FIMG-20240410-WA0596.jpg?alt=media&token=d7cde504-b1dd-4986-beaf-4179a96350b6',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FKin_Ordures_Decharge_Sauvage_MDMM_Juil_19.jpg?alt=media&token=221eabb1-59e9-4059-a6fc-fbc14b1adcc2',
      // ];
      //
      // PlaceItem p4 = PlaceItem(
      //   createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //   description: "Le long de la rue du Marché, des cartons et des déchets alimentaires non ramassés jonchent le sol, attirant des insectes et des animaux errants. Cette accumulation de déchets est due au manque de poubelles appropriées pour les commerçants du marché. Si la situation persiste, elle pourrait devenir un problème de santé publique.",
      //   latitude: -11.653585,
      //   longitude: 27.467416,
      // );
      // p4.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FWhatsApp-Image-2021-05-11-at-09.00.52.jpeg?alt=media&token=00fae151-5e5e-4c65-b40a-ae5c448b5e64',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Fantoine-giret-7-tszqjms4w-unsplash.jpg?alt=media&token=5daee7e7-9763-473b-831d-cb95b235286a',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Fguardia-inaslubrite.jpeg?alt=media&token=404b2694-c13e-4449-ae51-6c0a648cf13d',
      // ];
      //
      // PlaceItem p5 = PlaceItem(
      //   createdBy: 'LpdaBBxDKvTsSHP779HeGHqVK042',
      //   description: "Des piles de débris métalliques, de vieux pneus et d'autres déchets industriels ont été repérées dans un coin peu fréquenté de la zone industrielle. Ces déchets semblent être là depuis plusieurs mois et attirent des rongeurs. L'absence de gestion des déchets dans cette zone pourrait entraîner une pollution des sols et une contamination des nappes phréatiques.",
      //   latitude: -11.657526,
      //   longitude: 27.468812,
      // );
      // p5.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Fimages%20(1).jpeg?alt=media&token=5bddb12d-39cd-42d3-b0f1-3d63fddf5c26',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Fimages.jpeg?alt=media&token=6d0a4409-3767-4757-9cd5-d755a5c3278b',
      // ];
      //
      // PlaceItem p6 = PlaceItem(
      //   createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //   description: "Une grande quantité de déchets, principalement des déchets plastiques, a été observée le long de la rive de la rivière. Les déchets proviennent probablement des activités humaines en amont, ainsi que des promeneurs qui jettent leurs détritus sans se soucier des conséquences. Cette pollution menace directement la faune aquatique et pourrait également contaminer l'eau potable.",
      //   latitude: -11.6875978,
      //   longitude: 27.4977613,
      // );
      // p6.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Fordures.jpg?alt=media&token=87c87ac4-6413-4c9c-8e5d-9f82bd0c5063',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FIMG-20240410-WA0596.jpg?alt=media&token=d7cde504-b1dd-4986-beaf-4179a96350b6',
      // ];
      //
      // PlaceItem p7 = PlaceItem(
      //   createdBy: 'LpdaBBxDKvTsSHP779HeGHqVK042',
      //   description: "Des déchets divers, y compris des sacs en plastique, des bouteilles en verre et des papiers, se sont accumulés près de la zone de jeux pour enfants. Cette situation semble due à l'absence de poubelles dans les environs. Les déchets commencent à se disperser à cause du vent, posant un risque pour l'environnement et pour les enfants qui jouent à proximité.",
      //   latitude: -11.686347,
      //   longitude: 27.497933,
      // );
      // p7.photosUrls = [
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2Funnamed.jpg?alt=media&token=ee6a698d-c64a-48a5-a0b4-ce591663a09e',
      //   'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/places%2Fillustrations%2FDSC_0205.JPG?alt=media&token=4bf509c0-f91a-4f9c-9472-5cad98bdd6ca',
      // ];
      //
      // List<PlaceItem> places = [p1, p2, p3, p4, p5, p6, p7];
      // for (PlaceItem place in places) {
      //   await repository.add(place);
      // }

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