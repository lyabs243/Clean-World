import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/repositories/news_repository.dart';
import 'package:test/test.dart' as test;
import '../../../utils/my_material.dart';

class NewsTest {

  static final NewsRepository repository = NewsRepository();
  static NewsItem? item;

  static void run() async {
    debugPrint('==========Start News tests');

    add();
    getAll();
    get();
    update();
    delete();
  }

  static void add() {
    test.test('Add News', () async {
      NewsItem itemNews = NewsItem(
        createdBy: '1',
        title: 'Title test',
        photoUrl: 'https://picsum.photos/200/300?random=88',
        description: """[{"insert": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",  "attributes": {"header": 1}},{"insert": "\n"}]""",
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: NewsStatus.pending,
      );
      DocumentSnapshot? doc = await repository.add(itemNews);
      itemNews.document = doc;
      item = itemNews;

      // init data
      // List<NewsItem> news = [
      //   NewsItem(
      //     createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //     title: 'L\'importance de la biodiversité urbaine',
      //     photoUrl: 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/news%2Fillustrations%2F4-_4892526d-48b2-48d0-a042-4f9c9ce22b62.jpeg?alt=media&token=c2cec018-7bb7-4421-b9f8-23454dd916e9',
      //     description: """[{"insert": "La biodiversité en milieu urbain joue un rôle crucial dans le maintien de la santé de l'écosystème local. Voici comment vous pouvez encourager la biodiversité dans votre quartier :" },{ "insert": "\n\n" },{ "insert": "- ", "attributes": { "bold": true } },{"insert": "Plantez des fleurs indigènes : " },{ "insert": "Les plantes indigènes sont adaptées au climat local et nécessitent moins d'entretien. Elles attirent également les pollinisateurs comme les abeilles et les papillons, qui sont essentiels pour la reproduction des plantes." },{ "insert": "\n\n" },{ "insert": "- ", "attributes": { "bold": true } },{ "insert": "Installez des nichoirs et des hôtels à insectes : " },{ "insert": "Ces structures offrent un habitat sûr pour les oiseaux, les chauves-souris et les insectes utiles, contribuant ainsi à la diversité des espèces dans votre environnement urbain." },{ "insert": "\n\n" },{ "insert": "- ", "attributes": { "bold": true } },{ "insert": "Favorisez les espaces verts : " },{ "insert": "Encouragez la création et la préservation des parcs, des jardins communautaires et des toits verts dans votre quartier pour offrir des refuges à la faune et améliorer la qualité de l'air." },{ "insert": "\n"}]""",
      //     date: DateTime(2024, 8, 23, 14, 58),
      //     status: NewsStatus.pending,
      //   ),
      //   NewsItem(
      //     createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //     title: 'Les avantages du compostage à domicile',
      //     photoUrl: 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/news%2Fillustrations%2F3-_2ee9a0be-3409-4394-95a2-e9cd16d95af9.jpeg?alt=media&token=e0d02310-e386-4c3a-b647-1a6eb0729a1f',
      //     description: """[{"insert": "Le compostage est une méthode naturelle pour réduire les déchets organiques tout en enrichissant votre jardin. Voici pourquoi vous devriez envisager de commencer le compostage chez vous :" },{"insert": "\n\n" },{"insert": "- ", "attributes": { "bold": true }},{"insert": "Réduction des déchets : " },{"insert": "En compostant les restes de nourriture, les épluchures de légumes et les déchets de jardin, vous réduisez la quantité de déchets envoyés en décharge." },{"insert": "\n\n" },{"insert": "- ", "attributes": { "bold": true}},{"insert": "Amélioration du sol : " },{"insert": "Le compost est un excellent amendement pour le sol. Il améliore la structure du sol, retient l'humidité et fournit des nutriments essentiels pour vos plantes." },{"insert": "\n\n" },{"insert": "- ", "attributes": { "bold": true }},{ "insert": "Réduction des émissions de méthane : " },{"insert": "Les déchets organiques en décharge produisent du méthane, un puissant gaz à effet de serre. Le compostage réduit ces émissions en décomposant les déchets de manière aérobie." },{"insert": "\n"}]""",
      //     date: DateTime.now().subtract(const Duration(days: 1)),
      //     status: NewsStatus.published,
      //   ),
      //   NewsItem(
      //     createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //     title: 'Astuces pour un recyclage efficace',
      //     photoUrl: 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/news%2Fillustrations%2F2-_b6962d76-3ca2-4de7-9aec-1ff71190d900.jpeg?alt=media&token=1165cf44-0c50-4b7f-ba2f-fc14b76e6a17',
      //     description: """[{"insert": "Le recyclage est une étape cruciale pour réduire la quantité de déchets envoyés en décharge. Voici quelques astuces pour optimiser vos pratiques de recyclage :" },{"insert": "\n\n"},{"insert": "- ", "attributes": { "bold": true }},{"insert": "Rincez vos contenants recyclables : "},{"insert": "Avant de recycler les bouteilles en plastique, les canettes ou les pots en verre, rincez-les pour enlever tout résidu. Cela évite la contamination des autres matériaux recyclables."},{"insert": "\n\n"},{"insert": "- ", "attributes": { "bold": true }},{"insert": "Évitez de recycler les plastiques souples : "},{"insert": "Les sacs plastiques, les films plastiques et les emballages souples ne doivent pas être placés dans le bac de recyclage standard. Cherchez plutôt des points de collecte spécifiques pour ces matériaux." },{"insert": "\n\n" },{"insert": "- ", "attributes": { "bold": true }},{"insert": "Apprenez les codes de recyclage : "},{"insert": "Les symboles de recyclage sur les emballages indiquent le type de plastique ou de matériau. Familiarisez-vous avec ces codes pour savoir quels articles sont recyclables."},{"insert": "\n"}]""",
      //     date: DateTime.now().subtract(const Duration(days: 5)),
      //     status: NewsStatus.published,
      //   ),
      //   NewsItem(
      //     createdBy: 'gn2bWw0DvWcMftuzFwQGBxysIwQ2',
      //     title: 'Comment réduire votre empreinte carbone au quotidien',
      //     photoUrl: 'https://firebasestorage.googleapis.com/v0/b/lyabs-media.appspot.com/o/news%2Fillustrations%2F1-_9c14d6b6-723a-43c2-94e8-0d387d614032.jpeg?alt=media&token=f87662c1-76ac-4e9d-a07c-f6973ca3c668',
      //     description: """[{"insert": "Réduire votre empreinte carbone peut sembler une tâche complexe, mais il existe des gestes simples que vous pouvez adopter au quotidien pour faire la différence." },{"insert": "\n\n"},{"insert": "1. ", "attributes": { "bold": true }},{"insert": "Utilisez les transports en commun ou le covoiturage "},{"insert": "plutôt que de prendre votre voiture. En partageant vos trajets, vous contribuez à diminuer les émissions de gaz à effet de serre."},{"insert": "\n\n"},{"insert": "2. ", "attributes": { "bold": true }},{"insert": "Optez pour une alimentation plus végétale "},{"insert": "et locale. Réduire votre consommation de viande et privilégier les produits locaux diminue l'empreinte carbone liée à l'agriculture et au transport." },{"insert": "\n\n"},{ "insert": "3. ", "attributes": { "bold": true }},{"insert": "Réduisez votre consommation d'énergie à la maison "},{"insert": "en éteignant les appareils électriques quand ils ne sont pas utilisés et en privilégiant des sources d'énergie renouvelables." },{"insert": "\n" }]""",
      //     date: DateTime.now().add(const Duration(days: 2)),
      //     status: NewsStatus.published,
      //   ),
      // ];
      // for (NewsItem item in news) {
      //   await repository.add(item);
      // }

      test.expect(doc, test.isNot(null));
    });
  }

  static void getAll(){
    test.test('Get all news', () async {
      List<NewsItem> items = await repository.getItems();
      test.expect(items, test.isNotEmpty);
    });
  }

  static void get(){
    test.test('Get news', () async {
      NewsItem? itemPlace = await repository.get("${item?.document?.id}");
      test.expect(itemPlace, test.isNot(null));
    });
  }

  static void update(){
    test.test('Update news', () async {
      item!.description = 'Description updated';
      bool res = await repository.update(item!);
      test.expect(res, true);
    });
  }

  static void delete(){
    test.test('Delete news', () async {
      bool res = await repository.delete(item!);
      test.expect(res, true);
    });
  }

}