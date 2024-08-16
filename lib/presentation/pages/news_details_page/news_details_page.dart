import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:structure/presentation/widgets/image_container_widget.dart';
import 'package:structure/utils/my_material.dart';

class NewsDetailsPage extends StatelessWidget {

  const NewsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        margin: EdgeInsets.zero,
        child: NestedScrollView(
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
                  menuButton(context, NewsWidgetAction.getActions()),
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
                          argumentImageProvider: const NetworkImage('https://picsum.photos/200/300?random=49'),
                        }
                      );
                    },
                    child: ImageContainerWidget(
                      image: const NetworkImage('https://picsum.photos/200/300?random=49'),
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
                                          ).format(DateTime.now()),
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
                    'Pour sauver la terre, il faut agir maintenant et vite ' * 3,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: paddingMedium,),
                  QuillEditor.basic(
                    controller: QuillController(
                      document: Document.fromJson(
                        [
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 1,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 2,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 3,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 4,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 5,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'header': 6,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'bold': true,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'italic': true,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'underline': true,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'strike': true,
                            },
                          },
                          {
                            'insert': '\n\n',
                          },
                          {
                            'insert': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            'attributes': {
                              'color': '#ff0000',
                            },
                          },
                          {
                            'insert': '\n',
                          }
                          ],
                      ),
                      selection: const TextSelection.collapsed(offset: 0),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: paddingMedium,),
                ],
              ),
            ),
          ),
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
              action.onTap(context);
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