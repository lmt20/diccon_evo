import 'package:diccon_evo/extensions/i18n.dart';
import 'package:diccon_evo/screens/article/ui/article_history.dart';
import 'package:flutter/material.dart';
import '../../../models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/circle_button.dart';
import '../../components/head_sentence.dart';
import '../cubits/article_list_cubit.dart';
import 'components/reading_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ArticleListView extends StatelessWidget {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    final articleListCubit = context.read<ArticleListCubit>();
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ArticleListCubit, List<Article>>(
          builder: (context, state) {
            if (state.isEmpty) {
              articleListCubit.loadUp();
              return  Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ArticleListHeader(articleListCubit: articleListCubit),
                      const Expanded(child: Center(child: CircularProgressIndicator())),
                    ],
                  ));
            } else {
              return Column(
                children: [
                  /// Header
                  ArticleListHeader(articleListCubit: articleListCubit),
                  Expanded(
                    child: SingleChildScrollView(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            /// Head sentence
                            HeadSentence(
                              //Library of Infinite Adventures
                              listText: ["Library of".i18n, "Infinite Adventures".i18n],
                            ),

                            /// Sub sentence
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
                              child:  Text(
                                  "Within these walls, let the magic of words transport you to realms uncharted and dreams unbound.".i18n),
                            ),
                            /// Function button
                            CircleButtonBar(children: [
                              CircleButton(iconData: FontAwesomeIcons.heart, onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ArticleListHistoryView()));
                              }),
                              CircleButton(iconData: Icons.history, onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ArticleListHistoryView()));
                              }),
                            ],),
                          ],),
                        ),

                        /// List article
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final maxWidth = constraints.maxWidth;
                              int crossAxisCount;
                              // Adjust the number of columns based on the available width
                              if (maxWidth >= 1600) {
                                crossAxisCount = 5;
                              } else if (maxWidth >= 1300) {
                                crossAxisCount = 4;
                              } else if (maxWidth >= 1000) {
                                crossAxisCount = 3;
                              } else if (maxWidth >= 700) {
                                crossAxisCount = 2;
                              } else {
                                crossAxisCount = 1;
                              }

                              return GridView.builder(

                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  crossAxisCount: crossAxisCount,
                                  mainAxisExtent: 125,
                                  childAspectRatio:
                                  7 / 3, // Adjust the aspect ratio as needed
                                ),
                                itemBuilder: (context, index) {
                                  return ReadingTile(article: state[index]);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),),
                  ),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ArticleListHeader extends StatelessWidget {
  const ArticleListHeader({
    super.key,
    required this.articleListCubit,
  });

  final ArticleListCubit articleListCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleButton(
              iconData: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);
              }),
          const SizedBox(
            width: 16,
          ),
          // Text(
          //   "Reading Chamber".i18n,
          //   style: const TextStyle(fontSize: 28),
          // ),
          const Spacer(),
          PopupMenuButton(
            //splashRadius: 10.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(16.0),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Elementary".i18n),
                onTap: () => articleListCubit.sortElementary(),
              ),
              PopupMenuItem(
                child: Text("Intermediate".i18n),
                onTap: () => articleListCubit.sortIntermediate(),
              ),
              PopupMenuItem(
                child: Text("Advanced".i18n),
                onTap: () => articleListCubit.sortAdvanced(),
              ),
              const PopupMenuItem(
                enabled: false,
                height: 0,
                child: Divider(),
              ),
              PopupMenuItem(
                child: Text("All".i18n),
                onTap: () => articleListCubit.getAll(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
