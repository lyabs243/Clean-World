import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:structure/data/models/news_item.dart';
import 'package:structure/logic/cubits/news_cubit.dart';
import 'package:structure/logic/responses/news_response.dart';
import 'package:structure/logic/states/news_state.dart';
import 'package:structure/presentation/widgets/image_container_widget.dart';
import 'package:structure/presentation/widgets/response_code_widget.dart';
import 'package:structure/utils/my_material.dart';

class NewsDetailsPage extends StatelessWidget {

  final NewsItem news;
  final Function()? onDeleted;

  const NewsDetailsPage({super.key, required this.news, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(NewsState(news: news)),
      child: BlocListener<NewsCubit, NewsState>(
        listener: listener,
        child: Scaffold(
          body: Container(
            width: 1.sw,
            margin: EdgeInsets.zero,
            child: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {

                return NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        actions: [
                          menuButton(context, state, NewsWidgetAction.getActions()),
                        ],
                        expandedHeight: 0.35.sh,
                        floating: false,
                        pinned: true,
                        centerTitle: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  pageImageViewer,
                                  arguments: {
                                    argumentImageProvider: state.image,
                                  }
                              );
                            },
                            child: ImageContainerWidget(
                              image: state.image,
                              borderRadius: BorderRadius.zero,
                              colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.darken),
                              child: SizedBox(
                                width: 1.sw,
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: paddingMedium,
                                      left: paddingMedium,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                color: colorWhite,
                                              ),
                                              const SizedBox(width: paddingSMedium,),
                                              Text(
                                                  DateFormat(
                                                    AppLocalizations.of(context)!.dateFormat,
                                                    Localizations.localeOf(context).languageCode,
                                                  ).format(state.news.date),
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: colorWhite,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(paddingSMedium),
                      color:  Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: paddingMedium,),
                          Text(
                            state.news.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: paddingMedium,),
                          QuillEditor.basic(
                            controller: QuillController(
                              document: state.news.contentQuill,
                              selection: const TextSelection.collapsed(offset: 0),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(height: paddingMedium,),
                        ],
                      ),
                    ),
                  ),
                );

              },
            ),
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
      ResponseCodeWidget(
        context: context,
        item: state.response!,
      ).show();

      if (state.response!.code == NewsCode.deleted) {
        onDeleted?.call();
        Navigator.of(context).pop();
      }

      state.response = null;
    }
  }

}