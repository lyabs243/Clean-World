import 'package:structure/utils/my_material.dart';

class PlaceImageWidget extends StatelessWidget {

  final String url;
  final bool isAddButton;
  final Function()? onTap;
  final double widthRatio, heightRatio;
  final EdgeInsets margin;

  const PlaceImageWidget({super.key, this.url = '', this.onTap, this.widthRatio = 0.5, this.heightRatio = 0.4,
    this.margin = const EdgeInsets.all(paddingSMedium), this.isAddButton = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: heightRatio.sh,
          width: widthRatio.sw,
          decoration: BoxDecoration(
            color: (isAddButton)? null: colorPrimary,
            borderRadius: BorderRadius.circular(paddingLargeMedium),
            image: (!isAddButton)?
            DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ): null,
            border: (isAddButton)?
            Border.all(
              color: colorPrimary,
              width: 1,
            ): null,
          ),
          child: Visibility(
            visible: isAddButton,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: colorPrimary,
                  size: 0.1.sw,
                ),
                const SizedBox(height: paddingSMedium,),
                Text(
                  AppLocalizations.of(context)!.takePicture,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}