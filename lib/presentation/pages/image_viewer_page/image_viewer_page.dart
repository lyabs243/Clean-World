import 'package:photo_view/photo_view.dart';
import 'package:structure/utils/my_material.dart';

class ImageViewerPage extends StatelessWidget {

  final ImageProvider imageProvider;

  const ImageViewerPage({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: imageProvider,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: colorWhite,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

}