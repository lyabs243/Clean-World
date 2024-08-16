import 'dart:ui';

import 'package:structure/utils/my_material.dart';

class BoxDialog extends StatelessWidget {

  final Widget child;
  final double? height, width;
  final bool showCloseButton;
  final double contentPadding;
  final Color? iconColor;

  const BoxDialog({super.key, required this.child, this.height = 400, this.width = double.infinity,
    this.showCloseButton = true, this.contentPadding = paddingSMedium, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Dialog(
        elevation: 0,
        alignment: Alignment.center,
        backgroundColor: Colors.transparent,
        child: contentBox(context,),
      ),
    );
  }

  contentBox(BuildContext context,) {
    return Material(
        type: MaterialType.transparency,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(contentPadding),
                child: child,
              ),
              Visibility(
                visible: showCloseButton,
                child: Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: iconColor?? Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}