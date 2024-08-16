import 'package:intl/intl.dart';
import 'package:structure/utils/my_material.dart';

class NewsWidget extends StatelessWidget {

  const NewsWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.15.sh,
      margin: const EdgeInsets.only(bottom: paddingMedium),
      decoration: BoxDecoration(
        color: colorSecondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pushNamed(pageNewsDetails);
        },
        child: Row(
          children: [
            Expanded(
              flex: 30,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  color: colorPrimary,
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/200/300?random=18'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 70,
              child: Container(
                padding: const EdgeInsets.all(paddingSMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                'Pour sauver la terre, il faut agir maintenant et vite' * 3,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: menuButton(context, NewsWidgetAction.getActions()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: paddingSmall,),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              DateFormat(
                                AppLocalizations.of(context)!.dateFormat,
                                Localizations.localeOf(context).languageCode,
                              ).format(DateTime.now()),
                              style: Theme.of(context).textTheme. bodyMedium?.copyWith(
                                color: Colors.grey[600]
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, List<NewsWidgetAction> options) {
    return PopupMenuButton<NewsWidgetAction>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      itemBuilder: (BuildContext context) {

        return options.map((NewsWidgetAction action) {
          return PopupMenuItem(
            value: action,
            onTap: () {
            },
            child: Text(action.title(context)),
          );
        }).toList();
      },
      child: const Icon(
        Icons.more_vert,
      ),
    );
  }

}