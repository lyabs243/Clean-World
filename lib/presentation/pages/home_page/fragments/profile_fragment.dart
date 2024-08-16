import 'package:structure/presentation/widgets/settings_widget.dart';
import 'package:structure/utils/my_material.dart';

class ProfileFragment extends StatelessWidget {

  const ProfileFragment({super.key,});

  @override
  Widget build(BuildContext context) {

    bool isConnected = true;

    return Container(
      padding: const EdgeInsets.all(paddingSMedium),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: isConnected,
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
                          image: AssetImage(PathImage.avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingSMedium,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          'email@email.com',
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
              visible: isConnected,
              child: SettingsItemWidget(
                title: AppLocalizations.of(context)!.logout,
                icon: Icons.logout,
                onTap: () {
                },
              ),
            ),
            Visibility(
              visible: !isConnected,
              child: SettingsItemWidget(
                title: AppLocalizations.of(context)!.login,
                icon: Icons.login,
                onTap: () {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}