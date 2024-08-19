import 'package:structure/presentation/pages/home_page/home_page.dart';
import 'package:structure/presentation/pages/image_viewer_page/image_viewer_page.dart';
import 'package:structure/presentation/pages/news_details_page/news_details_page.dart';
import 'package:structure/presentation/pages/set_news_page/set_news_page.dart';
import 'package:structure/presentation/pages/set_place_page/set_place_page.dart';
import 'package:structure/presentation/pages/sign_in_page/sign_in_page.dart';
import 'package:structure/presentation/router/no_animation_route.dart';
import 'package:structure/utils/my_material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {

    Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
    Widget? page;

    switch (settings.name) {
      case pageHome:
        page = const HomePage();
        break;
      case pageSignIn:
        page = const SignInPage();
      case pageSetPlace:
        page = SetPlacePage(
          place: arguments?[argumentPlace],
        );
        break;
      case pageImageViewer:
        page = ImageViewerPage(
          imageProvider: arguments?[argumentImageProvider] as ImageProvider,
        );
        break;
      case pageNewsDetails:
        page = const NewsDetailsPage(
        );
        break;
      case pageSetNews:
        page = SetNewsPage(
          edit: arguments?[argumentEdit]?? false,
        );
        break;
      default:
    }

    if (page != null) {

      if (arguments != null && (arguments[argumentIsNOAnimation]?? false)) {
        return NoAnimationMaterialPageRoute(builder: (_) => page!);
      }

      return MaterialPageRoute(builder: (_) => page!);
    }

    return null;
  }
}