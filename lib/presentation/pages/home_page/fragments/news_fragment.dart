import 'package:structure/presentation/widgets/badge_widget.dart';
import 'package:structure/presentation/widgets/news_widget.dart';
import 'package:structure/utils/my_material.dart';

class NewsFragment extends StatelessWidget {

  const NewsFragment({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(paddingSMedium),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      BadgeWidget(
                        text: AppLocalizations.of(context)!.published,
                        backgroundColor: colorPrimary,
                        borderColor: Colors.transparent,
                        textColor: colorWhite,
                        onPressed: () {
                        },
                      ),
                      const SizedBox(width: paddingSMedium,),
                      BadgeWidget(
                        text: AppLocalizations.of(context)!.pending,
                        backgroundColor: colorSecondary.withOpacity(0.1),
                        borderColor: Colors.transparent,
                        textColor: colorPrimary,
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: paddingSMedium,),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(pageSetNews,);
                },
                  icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.publish),
              ),
            ],
          ),
          const SizedBox(height: paddingMedium,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  18,
                  (index) {
                    return const NewsWidget();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}