import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/presentation/dialogs/add_images_dialog.dart';
import 'package:structure/presentation/dialogs/box_dialog.dart';
import 'package:structure/presentation/widgets/circle_button_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/utils/my_material.dart';

class PlaceDetailsSheet extends StatefulWidget {

  final ValueNotifier<bool> isExpanded;
  final PlaceItem place;
  final UserItem? user;
  final Function()? onOpenInMap, onShare, onDelete;

  const PlaceDetailsSheet({super.key, required this.isExpanded, required this.place, this.user,
    this.onOpenInMap, this.onShare, this.onDelete});

  @override
  PlaceDetailsSheetState createState() => PlaceDetailsSheetState();
}

class PlaceDetailsSheetState extends State<PlaceDetailsSheet> {

  late PlaceItem place;

  PlaceDetailsSheetState();

  @override
  void initState() {
    super.initState();
    place = widget.place;
  }

  @override
  Widget build(BuildContext context) {

    UserItem? current = context.read<AppCubit>().state.user;

    return DraggableScrollableSheet(
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            widget.isExpanded.value = notification.extent == notification.maxExtent;
            return true;
          },
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.isExpanded,
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                image: (widget.user?.photoUrl.isNotEmpty?? false)?
                                                NetworkImage(widget.user!.photoUrl) as ImageProvider:
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
                                                widget.user?.name?? '',
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              ),
                                              Text(
                                                DateFormat(
                                                  AppLocalizations.of(context)!.dateFormat,
                                                  Localizations.localeOf(context).languageCode,
                                                ).format(place.createdAt),
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
                                          onPressed: () {
                                            widget.onShare?.call();
                                          },
                                        ),
                                        Visibility(
                                          visible: current?.authId == place.createdBy || (current?.isAdmin?? false),
                                          child: Row(
                                            children: [
                                              const SizedBox(width: paddingSmall,),
                                              CircleButtonWidget(
                                                icon: Icons.edit,
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(
                                                    pageSetPlace,
                                                    arguments: {argumentPlace: place},
                                                  ).then((value) {
                                                    if (value != null && value is PlaceItem) {
                                                      setState(() {
                                                        place = value;
                                                      });
                                                    }
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: paddingSmall,),
                                              CircleButtonWidget(
                                                icon: Icons.delete,
                                                onPressed: () {
                                                  AppDialog.showConfirmDialog(
                                                    context,
                                                    AppLocalizations.of(context)!.wantDeletePlace,
                                                  ).then((value) {
                                                    if (value != null && value) {
                                                      widget.onDelete?.call();
                                                      Navigator.of(context).pop();
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
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
                                      onPressed: () {
                                        widget.onOpenInMap?.call();
                                      },
                                    ),
                                    const SizedBox(width: paddingSMedium,),
                                    AppButtonWidget(
                                      context: context,
                                      text: AppLocalizations.of(context)!.addImages,
                                      icon: Icons.photo_camera,
                                      onPressed: () {
                                        bool isConnected = context.read<AppCubit>().state.isConnected;
                                        if (!isConnected) {
                                          AppDialog.showAuthRequiredDialog(context);
                                        } else {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext contextIN) {
                                              return BoxDialog(
                                                height: null,
                                                child: AddImagesDialog(place: place,),
                                              );
                                            },
                                          ).then((value) {
                                            if (value != null && value is PlaceItem) {
                                              setState(() {
                                                place = value;
                                              });
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: paddingMedium,),
                                SizedBox(
                                  height: 0.3.sh,
                                  width: 1.sw,
                                  child: ListView.builder(
                                    itemCount: place.photosUrls.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return PlaceImageWidget(
                                        url: place.photosUrls[index],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: paddingMedium,),
                                Text(
                                  place.description,
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