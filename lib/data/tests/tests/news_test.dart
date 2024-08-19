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
        description: """[{"insert": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",  "attributes": {"header": 1}},{"insert": "\\n"}]""",
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: NewsStatus.pending,
      );
      DocumentSnapshot? doc = await repository.add(itemNews);
      itemNews.document = doc;
      item = itemNews;

      // init data
      // List<NewsItem> news = [
      //   NewsItem(
      //     createdBy: '1',
      //     title: 'Protegeons la nature',
      //     photoUrl: 'https://picsum.photos/200/300?random=88',
      //     description: """[{"insert": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",  "attributes": {"header": 1}},{"insert": "\\n"}]""",
      //     date: DateTime.now().subtract(const Duration(days: 1)),
      //     status: NewsStatus.pending,
      //   ),
      //   NewsItem(
      //     createdBy: '1',
      //     title: 'Les animaux en danger, agissons!',
      //     photoUrl: 'https://picsum.photos/200/300?random=55',
      //     description: """[{"insert": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",  "attributes": {"header": 1}},{"insert": "\\n"}]""",
      //     date: DateTime.now().subtract(const Duration(days: 1)),
      //     status: NewsStatus.published,
      //   ),
      //   NewsItem(
      //     createdBy: '1',
      //     title: 'Sauvons les abeilles',
      //     photoUrl: 'https://picsum.photos/200/300?random=33',
      //     description: """[{"insert": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",  "attributes": {"header": 1}},{"insert": "\\n"}]""",
      //     date: DateTime.now().subtract(const Duration(days: 5)),
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