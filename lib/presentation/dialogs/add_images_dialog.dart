import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/utils/my_material.dart';

class AddImagesDialog extends StatelessWidget {

  const AddImagesDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 1.sw,
      height: 0.55.sh,
      margin: const EdgeInsets.only(top: paddingMedium),
      padding: const EdgeInsets.symmetric(horizontal: paddingSmall, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              AppLocalizations.of(context)!.addImages,
              style: Theme.of(context).textTheme.titleLarge
          ),
          const SizedBox(height: paddingSMedium,),
          Expanded(
            child: Stack(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: paddingLargeMedium,
                  mainAxisSpacing: paddingLargeMedium,
                  children: [
                    const PlaceImageWidget(
                      widthRatio: 0.4,
                      heightRatio: 0.25,
                      isAddButton: true,
                      margin: EdgeInsets.zero,
                    ),
                    ... List.generate(
                      3,
                          (index) {
                        return PlaceImageWidget(
                          url: 'https://picsum.photos/200/300?random=${55+index}',
                          widthRatio: 0.4,
                          heightRatio: 0.25,
                          margin: EdgeInsets.zero,
                          closeButtonPositionRight: 0,
                          onClose: () {},
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: AppButtonWidget(
                    context: context,
                    text: AppLocalizations.of(context)!.publish,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

}