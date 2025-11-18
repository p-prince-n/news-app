import 'package:flutter/material.dart';
import 'package:news_app/components/blog_tile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/constants/constant.dart';
import 'package:news_app/models/artical_model.dart';
import 'package:news_app/models/category_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  const HomePage({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> news_data = [];
  List<CategoryModel>? categoryList = [];
  bool _loading = true;

  void getTopHeadLineData() async {
    news_data = await getTopHeadlines();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categoryList = getCategoryList();
    getTopHeadLineData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('NEWS APP'),
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
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categoryList!.length,
              itemBuilder: (context, idx) {
                return CategoryTile(
                  tileName: categoryList![idx].categoryName,
                  imageurl: categoryList![idx].imgUrl,
                );
              },
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 2,
            width: double.infinity,
            color: widget.isDark ? Colors.white : Colors.black,
          ),
          SizedBox(height: 10),
          Text(
            'Top Headlines',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          SizedBox(height: 5),
          Expanded(
            child:
                _loading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: news_data.length,
                      itemBuilder: (context, idx) {
                        return BlogTile(
                          isDark: widget.isDark,
                          toggleTheme: widget.toggleTheme,
                          author: news_data[idx].author!,
                          title: news_data[idx].title,
                          description: news_data[idx].description!,
                          urlToImage: news_data[idx].urlToImage!,
                          publishedAt: news_data[idx].publishedAt!,
                          articalUrl: news_data[idx].url,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
