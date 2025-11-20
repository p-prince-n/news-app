import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:news_app/components/blog_tile.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/constants/constant.dart';
import 'package:news_app/models/artical_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/views/category_news.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> newsData = [];
  List<CategoryModel>? categoryList = [];
  bool _loading = true;

  int page = 1;
  final int pageSize = 10;

  bool hasInternet = true;
  StreamSubscription? connectionSub;

  Future<void> getTopHeadLineData() async {
    setState(() => _loading = true);

    newsData = await getUSNews(page: page, pageSize: pageSize);

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();

    categoryList = getCategoryList();

    // Listen for connectivity using latest API (returns List)
    connectionSub = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      bool connected =
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet);

      setState(() => hasInternet = connected);

      if (connected) {
        getTopHeadLineData();
      }
    });

    getTopHeadLineData();
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    super.dispose();
  }

  Widget noInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 15),
          Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please check your network and try again.",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              getTopHeadLineData(); // retry
            },
            icon: Icon(Icons.refresh),
            label: Text("Retry"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'NEWS APP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 1,
          actions: [
            Tooltip(
              message: "Top Headlines",
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CategoryNews(
                            category: "Top Headlines",
                            toggleTheme: widget.toggleTheme,
                            isDark: widget.isDark,
                            fetchCategoryData: false,
                          ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.newspaper, size: 28),
                ),
              ),
            ),
            IconButton(
              onPressed: widget.toggleTheme,
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
          // Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList!.length,
              itemBuilder: (context, idx) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => CategoryNews(
                              category: categoryList![idx].categoryName,
                              toggleTheme: widget.toggleTheme,
                              isDark: widget.isDark,
                            ),
                      ),
                    );
                  },
                  child: CategoryTile(
                    tileName: capitalizeFirstChar(
                      category: categoryList![idx].categoryName,
                    ),
                    imageurl: categoryList![idx].imgUrl,
                  ),
                );
              },
            ),
          ),

          // Divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 2,
            width: double.infinity,
            color: widget.isDark ? Colors.white : Colors.black,
          ),

          SizedBox(height: 10),

          // MAIN CONTENT (INTERNET CHECK)
          Expanded(
            child:
                !hasInternet
                    ? noInternetWidget()
                    : _loading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                      itemCount: newsData.length,
                      itemBuilder: (context, idx) {
                        return BlogTile(
                          isDark: widget.isDark,
                          toggleTheme: widget.toggleTheme,
                          author: newsData[idx].author ?? "",
                          title: newsData[idx].title,
                          description: newsData[idx].description ?? "",
                          urlToImage: newsData[idx].urlToImage ?? "",
                          publishedAt: newsData[idx].publishedAt ?? "",
                          articalUrl: newsData[idx].url,
                        );
                      },
                    ),
          ),

          // Pagination
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Button
                ElevatedButton(
                  onPressed:
                      page > 1
                          ? () {
                            setState(() {
                              page--;
                            });
                            getTopHeadLineData();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Previous"),
                ),

                SizedBox(width: 20),

                Text(
                  "Page: $page",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                SizedBox(width: 20),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page++;
                    });
                    getTopHeadLineData();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
