import 'package:structure/presentation/pages/sign_in_page/widgets/sign_in_content_widget.dart';
import 'package:structure/utils/my_material.dart';

class SignInPage extends StatelessWidget {

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignInContentWidget(),
      ),
    );
  }

}