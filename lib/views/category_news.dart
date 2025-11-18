import 'package:flutter/material.dart';
import 'package:news_app/components/blog_tile.dart';
import 'package:news_app/constants/constant.dart';
import 'package:news_app/models/artical_model.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  final VoidCallback toggleTheme;
  final bool isDark;
  bool fetchCategoryData;
  CategoryNews({
    super.key,
    required this.category,
    required this.toggleTheme,
    required this.isDark,
    this.fetchCategoryData = true,
  });

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> newsData = [];
  bool _loading = true;

  void getTopHeadLineDataCategory() async {
    newsData = await getTopHeadlinesCategory(category: widget.category);
    setState(() {
      _loading = false;
    });
  }

  void getTopHeadLineData() async {
    newsData = await getTopHeadlines();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.fetchCategoryData
        ? getTopHeadLineDataCategory()
        : getTopHeadLineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(capitalizeFirstChar(category: widget.category)),
          centerTitle: true,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () => widget.toggleTheme(),
              icon: Icon(
                widget.isDark ? Icons.light_mode : Icons.dark_mode,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _loading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: newsData.length,
                      itemBuilder: (context, idx) {
                        return BlogTile(
                          isDark: widget.isDark,
                          toggleTheme: widget.toggleTheme,
                          author: newsData[idx].author!,
                          title: newsData[idx].title,
                          description: newsData[idx].description!,
                          urlToImage: newsData[idx].urlToImage!,
                          publishedAt: newsData[idx].publishedAt!,
                          articalUrl: newsData[idx].url,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
