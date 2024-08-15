import 'package:fluttericon/font_awesome_icons.dart';
import 'package:structure/utils/my_material.dart';

class SignInContentWidget extends StatelessWidget {

  const SignInContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: paddingSMedium,
        right: paddingSMedium * 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(paddingLargeMedium),
                  image: DecorationImage(
                    image: AssetImage(PathImage.logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                AppLocalizations.of(context)!.appSlogan,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: 1.sw,
                child: AppButtonWidget(
                  text: AppLocalizations.of(context)!.signInWithGoogle,
                  icon: FontAwesome.google,
                  isLoading: false,
                  context: context,
                  primaryColor: colorPrimary,
                  foregroundColor: Colors.white,
                  paddingVertical: paddingLargeMedium,
                  borderColor: Colors.black,
                  highlightColor: Colors.black.withOpacity(0.1),
                  showBorder: true,
                  enabled: true,
                  onPressed: () {
                    Navigator.of(context).pushNamed(pageHome);
                  },
                ),
              ),
              Container(
                width: 1.sw,
                margin: const EdgeInsets.only(top: paddingLarge),
                child: AppButtonWidget(
                  text: AppLocalizations.of(context)!.continueAsGuest,
                  icon: FontAwesome.user_secret,
                  isLoading: false,
                  context: context,
                  enabled: true,
                  showBorder: true,
                  primaryColor: Colors.white,
                  foregroundColor: colorPrimary,
                  paddingVertical: paddingLargeMedium,
                  highlightColor: Colors.black.withOpacity(0.1),
                  onPressed: () {
                    Navigator.of(context).pushNamed(pageHome);
                  },
                ),
              ),
            ],
          ),
          //copyright
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.copyright(DateTime.now().year),
                style: const TextStyle(
                  fontSize: textSizeSMedium,
                ),
              ),
              const SizedBox(height: paddingMedium,),
            ],
          ),
        ],
      ),
    );
  }

}