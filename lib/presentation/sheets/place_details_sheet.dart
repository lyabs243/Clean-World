import 'package:intl/intl.dart';
import 'package:structure/presentation/widgets/circle_button_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/utils/my_material.dart';

class PlaceDetailsSheet extends StatelessWidget {

  final ValueNotifier<bool> isExpanded;

  const PlaceDetailsSheet({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            isExpanded.value = notification.extent == notification.maxExtent;
            return true;
          },
          child: ValueListenableBuilder<bool>(
            valueListenable: isExpanded,
            builder: (context, value, child) {
              return Column(
                children: [
                  if (value)
                    AppBar(
                      title: Text(AppLocalizations.of(context)!.details),
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          if (!value)
                            Container(
                              height: 5,
                              width: 50,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: paddingMedium, right: paddingMedium, bottom: paddingMedium),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
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
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              Text(
                                                DateFormat(AppLocalizations.of(context)!.dateFormat).format(DateTime.now()),
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: colorSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: paddingSMedium,),
                                    Row(
                                      children: [
                                        CircleButtonWidget(
                                          icon: Icons.share,
                                          onPressed: () {},
                                        ),
                                        const SizedBox(width: paddingSmall,),
                                        CircleButtonWidget(
                                          icon: Icons.edit,
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              pageSetPlace,
                                              arguments: {argumentEdit: true},
                                            );
                                          },
                                        ),
                                        const SizedBox(width: paddingSmall,),
                                        CircleButtonWidget(
                                          icon: Icons.delete,
                                          onPressed: () {},
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: paddingMedium,),
                                Row(
                                  children: [
                                    AppButtonWidget(
                                      context: context,
                                      text: AppLocalizations.of(context)!.openInMaps,
                                      icon: Icons.map,
                                      onPressed: () {},
                                    ),
                                    const SizedBox(width: paddingSMedium,),
                                    AppButtonWidget(
                                      context: context,
                                      text: AppLocalizations.of(context)!.addImages,
                                      icon: Icons.photo_camera,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: paddingMedium,),
                                SizedBox(
                                  height: 0.3.sh,
                                  width: 1.sw,
                                  child: ListView.builder(
                                    itemCount: 8,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return PlaceImageWidget(
                                        url: 'https://picsum.photos/200/300?random=${15+index}',
                                        onTap: () {},
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: paddingMedium,),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec purus feugiat, molestie ipsum et, ultricies nunc. Nulla facilisi. Nullam nec nunc nec nunc ultricies nunc. Nulla facilisi. Nullam nec nunc nec nunc ultricies nunc.' * 8,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

}