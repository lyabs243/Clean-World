import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/data/models/user_item.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/news_cubit.dart';
import 'package:structure/logic/responses/news_response.dart';
import 'package:structure/logic/states/news_state.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class NewsWidget extends StatelessWidget {

  final NewsItem news;
  final Function()? onDeleted;

  const NewsWidget({super.key, required this.news, this.onDeleted});

  @override
  Widget build(BuildContext context) {

    UserItem? currentUser = context.read<AppCubit>().state.user;

    return BlocProvider<NewsCubit>(
      create: (context) => NewsCubit(NewsState(news: news)),
      child: BlocListener<NewsCubit, NewsState>(
        listener: listener,
        child: Container(
          width: 1.sw,
          height: 0.15.sh,
          margin: const EdgeInsets.only(bottom: paddingMedium),
          decoration: BoxDecoration(
            color: colorSecondary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    pageNewsDetails,
                    arguments: {
                      argumentNews: state.news,
                      argumentOnDeleted: onDeleted,
                    },
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          color: colorPrimary,
                          image: DecorationImage(
                            image: state.image,
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
                                        state.news.title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: currentUser?.isAdmin ?? false,
                                    child: menuButton(context, state, NewsWidgetAction.getActions()),
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
                                      ).format(state.news.date),
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
              );

            },
          ),
        ),
      ),
    );
  }

  Widget menuButton(BuildContext context, NewsState state, List<NewsWidgetAction> options) {
    return PopupMenuButton<NewsWidgetAction>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      itemBuilder: (BuildContext contextIn) {

        return options.map((NewsWidgetAction action) {
          return PopupMenuItem(
            value: action,
            onTap: () {
              action.onTap(context, state.news);
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

  void listener(BuildContext context, NewsState state) {
    if (state.response != null) {
      ResponseCodeWidget(context: context, item: state.response!).show();

      if (state.response!.code == NewsCode.deleted) {
        onDeleted?.call();
      }
    }
  }

}