import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:structure/presentation/widgets/app_edit_text_widget.dart';
import 'package:structure/presentation/widgets/picker_button_widget.dart';
import 'package:structure/presentation/widgets/place_image_widget.dart';
import 'package:structure/utils/my_material.dart';

class SetNewsPage extends StatelessWidget {

  final bool edit;
  final QuillController controller = QuillController(
    document: Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );

  SetNewsPage({super.key, this.edit = false});

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
                  AppLocalizations.of(context)!.title,
                  controller: TextEditingController(),
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
                        child: RadioListTile<bool>(
                          value: false,
                          groupValue: true,
                          title: Text(AppLocalizations.of(context)!.now),
                          onChanged: (value) {
                          },
                        ),
                      ),
                      const SizedBox(width: paddingMedium,),
                      Expanded(
                        flex: 1,
                        child: RadioListTile<bool>(
                          value: true,
                          groupValue: true,
                          title: Text(AppLocalizations.of(context)!.schedule),
                          onChanged: (value) {
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: paddingMedium,),
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: paddingMedium),
                    child: PickerButtonWidget(
                      title: DateFormat(AppLocalizations.of(context)!.completeDateFormat).format(DateTime.now()),
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
                            debugPrint('=========> confirm $date');
                          },
                          currentTime: DateTime.now(),
                          locale: picker.LocaleType.fr,
                        );
                      },
                    ),
                  ),
                ),
                PlaceImageWidget(
                  isAddButton: true,
                  heightRatio: 0.2,
                  onTap: () {},
                ),
                const SizedBox(height: paddingMedium,),
                QuillToolbar.simple(
                  controller: controller,
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
                    controller: controller,
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

}