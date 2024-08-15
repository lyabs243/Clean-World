import 'package:structure/presentation/pages/home_page/fragments/home_fragment.dart';

import '../../../utils/my_material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  HomeNavigation navigation = HomeNavigation.home;

  @override
  Widget build(BuildContext context) {
    return PageContainerWidget(
      child: Scaffold(
        body: SafeArea(
          child: body,
        ),
        floatingActionButton: Visibility(
          visible: navigation == HomeNavigation.home,
          child: FloatingActionButton(
            onPressed: () {
            },
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigation.index,
          onTap: (int index) {
            setState(() {
              navigation = HomeNavigation.values[index];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.newspaper),
              label: AppLocalizations.of(context)!.news,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget get body {
    switch (navigation) {
      case HomeNavigation.home:
        return const HomeFragment();
      case HomeNavigation.news:
        return const Column(
          children: [
            SizedBox(height: paddingMedium,),
            Text('News'),
          ],
        );
      case HomeNavigation.profile:
        return const Column(
          children: [
            SizedBox(height: paddingMedium,),
            Text('Profile'),
          ],
        );
    }
  }
}
