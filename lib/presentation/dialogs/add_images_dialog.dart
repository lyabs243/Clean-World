import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/set_place_cubit.dart';
import 'package:structure/logic/responses/set_place_response.dart';
import 'package:structure/logic/states/set_place_state.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class AddImagesDialog extends StatelessWidget {

  final PlaceItem place;

  const AddImagesDialog({super.key, required this.place});

  @override
  Widget build(BuildContext context) {

    UserItem current = context.read<AppCubit>().state.user!;

    return BlocProvider<SetPlaceCubit>(
      create: (context) => SetPlaceCubit(SetPlaceState(place: place), user: current),
      child: BlocListener<SetPlaceCubit, SetPlaceState>(
        listener: listener,
        child: Container(
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
                child: BlocBuilder<SetPlaceCubit, SetPlaceState>(
                  builder: (context, state) {

                    return Stack(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: paddingLargeMedium,
                          mainAxisSpacing: paddingLargeMedium,
                          children: [
                            PlaceImageWidget(
                              widthRatio: 0.4,
                              heightRatio: 0.25,
                              isAddButton: true,
                              margin: EdgeInsets.zero,
                              onTap: () {
                                context.read<SetPlaceCubit>().pickFile();
                              },
                            ),
                            ... List.generate(
                              state.imagePickerResults.length,
                              (index) {
                                return PlaceImageWidget(
                                  imagePickerResult: state.imagePickerResults[index],
                                  widthRatio: 0.4,
                                  heightRatio: 0.25,
                                  margin: EdgeInsets.zero,
                                  closeButtonPositionRight: 0,
                                  onClose: () {
                                    context.read<SetPlaceCubit>().removeFile(index);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: AppButtonWidget(
                            context: context,
                            text: (state.isLoading)?
                            '${AppLocalizations.of(context)!.loading}...':
                            AppLocalizations.of(context)!.publish,
                            onPressed: () {
                              context.read<SetPlaceCubit>().setPlace(addPhotos: true);
                            },
                          ),
                        ),
                      ],
                    );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  void listener(BuildContext context, SetPlaceState state) async {
    if (state.response != null) {
      await ResponseCodeWidget(
        context: context,
        item: state.response!,
      ).show();

      if (context.mounted && state.response!.code == SetPlaceCode.updated) {
        Navigator.of(context).pop(state.place);
      }

      state.response = null;
    }
  }

}