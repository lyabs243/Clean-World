import 'package:structure/utils/my_material.dart';

class BadgeWidget extends StatelessWidget {

  final String text;
  final Color backgroundColor, textColor;
  final Color? borderColor;
  final Function()? onPressed;
  final EdgeInsets margin;

  const BadgeWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.onPressed,
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Chip(
          label: Text(
            text,
            textScaler: const TextScaler.linear(0.8),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor,
            ),
          ),
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: borderColor ?? backgroundColor,
            ),
          ),
        ),
      ),
    );
  }

}