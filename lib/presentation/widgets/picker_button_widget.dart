import 'package:structure/utils/my_material.dart';

class PickerButtonWidget extends StatelessWidget {

  final String title;
  final String? label, badgeLabel;
  final Function() onTap;
  final IconData icon;
  final double widthRatio;

  const PickerButtonWidget({super.key, required this.title, required this.icon, required this.onTap, this.label,
    this.badgeLabel, this.widthRatio = 1.0});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: label != null,
            child: Column(
              children: [
                Text(
                    label?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: textSizeMedium
                    )
                ),
                const SizedBox(height: paddingSMedium),
              ],
            )
        ),
        InkWell(
          onTap: onTap,
          child: SizedBox(
            width: widthRatio.sw,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFFC2C2C2).withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(paddingSMedium),
                    child: Icon(icon, color: Colors.grey,),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: const EdgeInsets.all(paddingSMedium),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: const Color(0XFFC2C2C2), width: 1.0),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: textSizeMedium,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

  }

}