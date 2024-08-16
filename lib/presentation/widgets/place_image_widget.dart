import 'package:structure/utils/my_material.dart';

class PlaceImageWidget extends StatelessWidget {

  final String url;
  final Function()? onTap;

  const PlaceImageWidget({super.key, required this.url, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSMedium),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 0.4.sh,
          width: 0.5.sw,
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.circular(paddingLargeMedium),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

}