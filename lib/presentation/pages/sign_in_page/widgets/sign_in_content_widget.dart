import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/authentication_cubit.dart';
import 'package:structure/logic/states/authentication_state.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class SignInContentWidget extends StatelessWidget {

  const SignInContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
      create: (context) => AuthenticationCubit(AuthenticationState()),
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: listener,
        child: Padding(
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
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {

                  return Column(
                    children: [
                      SizedBox(
                        width: 1.sw,
                        child: AppButtonWidget(
                          text: AppLocalizations.of(context)!.signInWithGoogle,
                          icon: FontAwesome.google,
                          isLoading: state.isLoading && state.type == AuthType.google,
                          context: context,
                          primaryColor: colorPrimary,
                          foregroundColor: Colors.white,
                          paddingVertical: paddingLargeMedium,
                          borderColor: Colors.black,
                          highlightColor: Colors.black.withOpacity(0.1),
                          showBorder: true,
                          enabled: true,
                          onPressed: () {
                            context.read<AuthenticationCubit>().signInWithGoogle();
                          },
                        ),
                      ),
                      Container(
                        width: 1.sw,
                        margin: const EdgeInsets.only(top: paddingLarge),
                        child: AppButtonWidget(
                          text: AppLocalizations.of(context)!.continueAsGuest,
                          icon: FontAwesome.user_secret,
                          isLoading: state.isLoading && state.type == AuthType.guest,
                          context: context,
                          enabled: true,
                          showBorder: true,
                          primaryColor: Colors.white,
                          foregroundColor: colorPrimary,
                          paddingVertical: paddingLargeMedium,
                          highlightColor: Colors.black.withOpacity(0.1),
                          onPressed: () {
                            context.read<AuthenticationCubit>().signInAsGuest();
                          },
                        ),
                      ),
                    ],
                  );

                },
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
        ),
      ),
    );
  }

  listener(BuildContext context, AuthenticationState state) {

    if (state.user != null) {
      context.read<AppCubit>().setUser(user: state.user!, saveUser: true,);
      Navigator.of(context).pushNamedAndRemoveUntil(pageHome, (route) => false);
    }
    else if (state.response != null) {
      ResponseCodeWidget(context: context, item: state.response!).show();
      state.response = null;
    }

  }

}