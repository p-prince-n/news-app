import 'package:flutter/material.dart';
import 'package:news_app/components/category_tile.dart';
import 'package:news_app/constants/constant.dart';
import 'package:news_app/models/category_model.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  const HomePage({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel>? categoryList = [];
  @override
  void initState() {
    super.initState();
    categoryList = getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: AppBar(
          title: Text('NEWS APP'),
          centerTitle: true,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () => widget.toggleTheme(),
              icon: Icon(
                widget.isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.black26,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text('Hello World'),
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
        ],
      ),
    );
  }
}
