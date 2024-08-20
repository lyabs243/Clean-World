import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:structure/logic/cubits/app_cubit.dart';
import 'package:structure/logic/cubits/news_list_cubit.dart';
import 'package:structure/logic/states/app_state.dart';
import 'package:structure/logic/states/news_list_state.dart';
import 'package:structure/presentation/widgets/badge_widget.dart';
import 'package:structure/presentation/widgets/news_widget.dart';
import 'package:structure/utils/my_material.dart';

class NewsFragment extends StatelessWidget {

  final RefreshController _refreshController = RefreshController(initialRefresh: false,);

  NewsFragment({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsListCubit>(
      create: (context) => NewsListCubit(NewsListState()),
      child: Container(
        padding: const EdgeInsets.all(paddingSMedium),
        child: BlocBuilder<NewsListCubit, NewsListState>(
          builder: (context, state) {

            return Column(
              children: [
                BlocBuilder<AppCubit, AppState>(
                  builder: (contextApp, stateApp) {

                    return Visibility(
                        visible: stateApp.user?.isAdmin ?? false,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: paddingMedium),
                          child: Row(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Row(
                                    children: [
                                      BadgeWidget(
                                        text: AppLocalizations.of(context)!.published,
                                        backgroundColor: (state.status == NewsStatus.published)? colorPrimary: colorSecondary.withOpacity(0.1),
                                        borderColor: Colors.transparent,
                                        textColor: (state.status == NewsStatus.published)? colorWhite: colorPrimary,
                                        onPressed: () {
                                          context.read<NewsListCubit>().setStatus(NewsStatus.published);
                                        },
                                      ),
                                      const SizedBox(width: paddingSMedium,),
                                      BadgeWidget(
                                        text: AppLocalizations.of(context)!.pending,
                                        backgroundColor: (state.status == NewsStatus.pending)? colorPrimary: colorSecondary.withOpacity(0.1),
                                        borderColor: Colors.transparent,
                                        textColor: (state.status == NewsStatus.pending)? colorWhite: colorPrimary,
                                        onPressed: () {
                                          context.read<NewsListCubit>().setStatus(NewsStatus.pending);
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
                        )
                    );

                  },
                ),
                Expanded(
                  child: (state.isLoading)?
                  const Center(child: CircularProgressIndicator(),):
                  SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () async {
                      await context.read<NewsListCubit>().initData();
                      _refreshController.refreshCompleted();
                    },
                    onLoading: () async {
                      await context.read<NewsListCubit>().loadData();
                      _refreshController.loadComplete();
                    },
                    child: ListView.builder(
                      itemCount: state.news.length,
                      itemBuilder: (BuildContext context, int index) {
                        return NewsWidget(
                          key: ValueKey(state.news[index].document?.id),
                          news: state.news[index],
                          onDeleted: () {
                            context.read<NewsListCubit>().deleteItem(state.news[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );

          }
        ),
      ),
    );
  }

}