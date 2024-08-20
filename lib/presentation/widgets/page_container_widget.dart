import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:structure/data/models/notification_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/responses/app_response.dart';
import 'package:structure/logic/states/app_state.dart';
import 'package:structure/presentation/widgets/local_notification_widget.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/methods.dart';
import 'package:structure/utils/my_material.dart';

class PageContainerWidget extends StatelessWidget {

  final Widget child;

  const PageContainerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: listener,
      child: child,
    );
  }

  listener(BuildContext context, AppState state) {

    if (state.response != null) {
      if (state.response!.code == AppCode.loggedOut) {
        state.response = null;
        Navigator.pushNamedAndRemoveUntil(context, pageSignIn, (route) => false);
      }
      else {
        ResponseCodeWidget(context: context, item: state.response!).show();
      }

      state.response = null;
    }

    if (state.notification != null) {
      String page = state.notification!.page;
      Map<String, dynamic> arguments = state.notification!.arguments;

      switch (state.notification!.mode) {
        case NotificationMode.inApp:
          NotificationItem notification = state.notification!;
          showOverlayNotification(
                (context) => LocalNotificationWidget(notification: notification),
            duration: const Duration(milliseconds: 5000),
          );
          break;
        case NotificationMode.external:
          openPage(context, page, arguments);
          break;
      }

      state.notification = null;
    }

  }

}