import 'package:structure/utils/my_material.dart';

class SettingsItemWidget extends StatelessWidget {

  final String title;
  final IconData? icon;
  final Function()? onTap;
  final Color? foregroundColor;

  const SettingsItemWidget({super.key, required this.title, this.icon, this.onTap, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (icon != null)?
      CircleAvatar(
        backgroundColor: colorPrimary,
        child: Icon(icon, color: colorWhite,),
      ): null,
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor,
        ),
      ),
      trailing: Icon(
        Icons.navigate_next,
        color: foregroundColor,
      ),
      onTap: onTap,
    );
  }

}