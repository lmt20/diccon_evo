import 'package:diccon_evo/components/header.dart';
import 'package:diccon_evo/views/article_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class ArticleListView extends StatelessWidget {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Reading time',
        icon: Icons.chrome_reader_mode,
      ),
      body: LayoutBuilder(
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
            itemCount: Global.defaultArticleList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 7 / 3, // Adjust the aspect ratio as needed
            ),
            itemBuilder: (context, index) {
              return GridTile(
                child: GestureDetector(
                  onTap: () {
                    // Handle tap on article
                    // For example, navigate to article details page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticlePageView(
                                  content:
                                      Global.defaultArticleList[index].content,
                                  title: Global.defaultArticleList[index].title,
                                  imageUrl:
                                      Global.defaultArticleList[index].imageUrl ?? "",
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(
                                  backgroundColor: Colors.black45,
                                  color: Colors.black54,
                                ),
                                imageUrl:
                                    Global.defaultArticleList[index].imageUrl ??
                                        '',
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                                errorWidget: (context, String exception,
                                    dynamic stackTrace) {
                                  return Container(
                                    width: 100.0,
                                    height: 100.0,
                                    color: Colors
                                        .grey, // Display a placeholder color or image
                                    child: Center(
                                      child: Text('No Image'),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Global.defaultArticleList[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      Global.defaultArticleList[index]
                                          .shortDescription,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
