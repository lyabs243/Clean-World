import 'dart:ui';
import 'package:structure/utils/my_material.dart';

class AuthRequiredDialog extends StatelessWidget {

  const AuthRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.authRequired,
        ),
        icon: const Icon(Icons.lock),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.authRequiredText,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(pageSignIn, (route) => false);
            },
            child: Text(
              AppLocalizations.of(context)!.signInWithGoogle,
            ),
          ),
          // close button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.close,
            ),
          ),
        ],
      ),
    );

  }

}
