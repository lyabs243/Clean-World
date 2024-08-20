import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/set_news_cubit.dart';
import 'package:structure/logic/responses/set_news_response.dart';
import 'package:structure/logic/states/set_news_state.dart';
import 'package:structure/presentation/widgets/app_edit_text_widget.dart';
import 'package:structure/presentation/widgets/picker_button_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class SetNewsPage extends StatelessWidget {

  final NewsItem? news;

  const SetNewsPage({super.key, this.news});

  @override
  Widget build(BuildContext context) {

    UserItem user = context.read<AppCubit>().state.user!;

    return BlocProvider<SetNewsCubit>(
      create: (context) => SetNewsCubit(SetNewsState(news: news), user: user),
      child: BlocListener<SetNewsCubit, SetNewsState>(
        listener: listener,
        child: BlocBuilder<SetNewsCubit, SetNewsState>(
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
                      (
                          (state.news != null)?
                          AppLocalizations.of(context)!.update:
                          AppLocalizations.of(context)!.publish
                      ),
                    ),
                    onPressed: () {
                      context.read<SetNewsCubit>().setNews();
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
                          AppLocalizations.of(context)!.title,
                          controller: state.titleEditingController,
                          backgroundColor: colorPrimary.withOpacity(0.15),
                          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                          inputType: TextInputType.multiline,
                          borderRadius: 12,
                        ),
                        const SizedBox(height: paddingMedium,),
                        Text(
                          AppLocalizations.of(context)!.publish,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: RadioListTile<NewsStatus>(
                                  value: NewsStatus.published,
                                  groupValue: state.status,
                                  title: Text(AppLocalizations.of(context)!.now),
                                  onChanged: (value) {
                                    if (value != null) context.read<SetNewsCubit>().setStatus(value);
                                  },
                                ),
                              ),
                              const SizedBox(width: paddingMedium,),
                              Expanded(
                                flex: 1,
                                child: RadioListTile<NewsStatus>(
                                  value: NewsStatus.pending,
                                  groupValue: state.status,
                                  title: Text(AppLocalizations.of(context)!.schedule),
                                  onChanged: (value) {
                                    if (value != null) context.read<SetNewsCubit>().setStatus(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: paddingMedium,),
                        Visibility(
                          visible: state.status == NewsStatus.pending,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: paddingMedium),
                            child: PickerButtonWidget(
                              title: DateFormat(AppLocalizations.of(context)!.completeDateFormat).format(state.publicationDate),
                              icon: Icons.calendar_month,
                              onTap: () {
                                picker.DatePicker.showDateTimePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  theme: const picker.DatePickerTheme(
                                    doneStyle: TextStyle(color: colorPrimary),
                                  ),
                                  maxTime: DateTime.now().add(const Duration(days: 365*5)), onChanged: (date) {
                                  debugPrint('===========> change $date');
                                },
                                  onConfirm: (date) {
                                    context.read<SetNewsCubit>().setDate(date);
                                  },
                                  currentTime: state.publicationDate,
                                  locale: picker.LocaleType.fr,
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PlaceImageWidget(
                              isAddButton: state.imagePickerResult == null && state.news?.photoUrl == null,
                              heightRatio: 0.2,
                              imagePickerResult: state.imagePickerResult,
                              url: state.news?.photoUrl?? '',
                              closeButtonPositionRight: 5,
                              onClose: (state.imagePickerResult == null)?
                              null:
                                  () {
                                context.read<SetNewsCubit>().removeFile();
                              },
                              onTap: (state.imagePickerResult != null)?
                              null:
                                  () {
                                context.read<SetNewsCubit>().pickFile();
                              },
                            ),
                            const SizedBox(width: paddingSmall,),
                            AppButtonWidget(
                              context: context,
                              text: AppLocalizations.of(context)!.takePicture,
                              onPressed: () {
                                context.read<SetNewsCubit>().pickFile();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: paddingMedium,),
                        QuillToolbar.simple(
                          controller: state.controller,
                        ),
                        const SizedBox(height: paddingSmall,),
                        Container(
                          height: 0.5.sh,
                          padding: const EdgeInsets.all(paddingSMedium),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorSecondary,
                              width: 2,
                            ),
                          ),
                          child: QuillEditor.basic(
                            controller: state.controller,
                          ),
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

  void listener(BuildContext context, SetNewsState state) {
    if (state.response != null) {
      ResponseCodeWidget(context: context, item: state.response!).show();

      if (state.response!.code == SetNewsCode.added || state.response!.code == SetNewsCode.updated) {
        Navigator.of(context).pop(state.news);
      }

      state.response = null;
    }
  }

}