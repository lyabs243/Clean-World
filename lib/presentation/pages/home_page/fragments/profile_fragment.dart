import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/states/app_state.dart';
import 'package:structure/presentation/widgets/settings_widget.dart';
import 'package:structure/utils/my_material.dart';

class ProfileFragment extends StatelessWidget {

  const ProfileFragment({super.key,});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        return Container(
          padding: const EdgeInsets.all(paddingSMedium),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible: state.isConnected,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: paddingMedium),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: paddingSMedium),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: (state.user?.photoUrl != null && state.user!.photoUrl.isNotEmpty)?
                                NetworkImage(state.user!.photoUrl) as ImageProvider:
                                AssetImage(PathImage.avatar),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: paddingSMedium,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user?.name ?? '',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              state.user?.email ?? '',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SettingsItemWidget(
                  title: AppLocalizations.of(context)!.about,
                  icon: Icons.info,
                  onTap: () {
                    AppDialog.showAboutAppDialog(context);
                  },
                ),
                Visibility(
                  visible: state.isConnected,
                  child: SettingsItemWidget(
                    title: AppLocalizations.of(context)!.logout,
                    icon: Icons.logout,
                    onTap: () {
                      context.read<AppCubit>().logout();
                    },
                  ),
                ),
                Visibility(
                  visible: !state.isConnected,
                  child: SettingsItemWidget(
                    title: AppLocalizations.of(context)!.login,
                    icon: Icons.login,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, pageSignIn, (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
        );

      },
    );
  }

}