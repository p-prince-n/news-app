import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  bool hasInternet = true;
  StreamSubscription? connectionSub;

  Widget noInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          SizedBox(height: 15),
          Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Please check your network and try again.",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _reloadData();
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

  void getTopHeadLineDataCategory() async {
    setState(() => _loading = true);

    newsData = await getTopHeadlinesCategory(category: widget.category);

    setState(() => _loading = false);
  }

  void getTopHeadLineData() async {
    setState(() => _loading = true);

    newsData = await getTopHeadlines();

    setState(() => _loading = false);
  }

  void _reloadData() {
    if (widget.fetchCategoryData) {
      getTopHeadLineDataCategory();
    } else {
      getTopHeadLineData();
    }
  }

  @override
  void initState() {
    super.initState();

    // INTERNET STREAM LISTENER
    connectionSub = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      bool connected =
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet);

      setState(() => hasInternet = connected);

      if (connected) {
        _reloadData(); // auto fetch
      }
    });

    _reloadData();
  }

  @override
  void dispose() {
    connectionSub?.cancel();
    super.dispose();
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
                !hasInternet
                    ? noInternetWidget()
                    : _loading
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                      scrollDirection: Axis.vertical,
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
        ],
      ),
    );
  }
}
