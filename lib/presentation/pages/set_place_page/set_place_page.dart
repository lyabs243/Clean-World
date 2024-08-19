import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/data/models/place_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/set_place_cubit.dart';
import 'package:structure/logic/responses/set_place_response.dart';
import 'package:structure/logic/states/set_place_state.dart';
import 'package:structure/presentation/widgets/app_edit_text_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class SetPlacePage extends StatelessWidget {

  final PlaceItem? place;

  const SetPlacePage({super.key, this.place});

  @override
  Widget build(BuildContext context) {

    UserItem current = context.read<AppCubit>().state.user!;

    return BlocProvider<SetPlaceCubit>(
      create: (context) => SetPlaceCubit(SetPlaceState(place: place,), user: current),
      child: BlocListener<SetPlaceCubit, SetPlaceState>(
        listener: listener,
        child: BlocBuilder<SetPlaceCubit, SetPlaceState>(
          builder: (context, state) {

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
                      (state.isLoading)?
                      '${AppLocalizations.of(context)!.loading}...':
                      ((state.place != null)?
                      AppLocalizations.of(context)!.update:
                      AppLocalizations.of(context)!.publish),
                    ),
                    onPressed: () {
                      context.read<SetPlaceCubit>().setPlace();
                    },
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
                          controller: state.descriptionEditingController,
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
                                  onClose: () {
                                    context.read<SetPlaceCubit>().removeFile(index);
                                  },
                                );
                              },
                            ),
                            ... List.generate(
                              state.place?.photosUrls.length ?? 0,
                              (index) {
                                return PlaceImageWidget(
                                  url: state.place!.photosUrls[index],
                                  widthRatio: 0.4,
                                  heightRatio: 0.25,
                                  margin: EdgeInsets.zero,
                                  onClose: () {
                                    context.read<SetPlaceCubit>().removePhotoUrl(index);
                                  },
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

          },
        ),
      ),
    );
  }

  void listener(BuildContext context, SetPlaceState state) {
    if (state.response != null) {
      ResponseCodeWidget(
        context: context,
        item: state.response!,
      ).show();

      if (state.response!.code == SetPlaceCode.updated || state.response!.code == SetPlaceCode.added) {
        Navigator.of(context).pop(state.place);
      }

      state.response = null;
    }
  }

}