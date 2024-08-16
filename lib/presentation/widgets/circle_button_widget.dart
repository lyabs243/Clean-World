import 'package:structure/utils/my_material.dart';

class CircleButtonWidget extends StatelessWidget {

  final IconData icon;
  final Function()? onPressed;
  final Color backgroundColor, foregroundColor;

  const CircleButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor = colorPrimary,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: backgroundColor,
        child: Icon(
          icon,
          color: foregroundColor,
          size: 20,
        ),
      ),
    );
  }

}