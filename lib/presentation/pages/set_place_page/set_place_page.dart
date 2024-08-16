import 'package:structure/presentation/widgets/app_edit_text_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/utils/my_material.dart';

class SetPlacePage extends StatelessWidget {

  final bool edit;

  const SetPlacePage({super.key, this.edit = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.publish),
            label: Text(
              (edit)?
              AppLocalizations.of(context)!.update:
              AppLocalizations.of(context)!.publish,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingSMedium),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppEditTextWidget(
                  '${AppLocalizations.of(context)!.describeSituation}...',
                  controller: TextEditingController(),
                  backgroundColor: colorPrimary.withOpacity(0.15),
                  padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                  inputType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 5,
                  borderRadius: 12,
                  height: 120,
                ),
                const SizedBox(height: paddingMedium,),
                Text(
                  AppLocalizations.of(context)!.addLeastOneImage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: paddingMedium,),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      9,
                      (index) {
                        return PlaceImageWidget(
                          url: 'https://picsum.photos/200/300?random=${55+index}',
                          widthRatio: 0.4,
                          heightRatio: 0.25,
                          margin: EdgeInsets.zero,
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }

}