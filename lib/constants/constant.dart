import 'dart:convert';

import 'package:news_app/models/artical_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/models/news_response_model.dart';

List<CategoryModel> getCategoryList() {
  final List<Map<String, String>> categories = [
    {
      "categoryName": "business",
      "categoryImg":
          "https://plus.unsplash.com/premium_photo-1661301084402-1a0452b5850e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "entertainment",
      "categoryImg":
          "https://plus.unsplash.com/premium_photo-1710409625244-e9ed7e98f67b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "general",
      "categoryImg":
          "https://images.unsplash.com/photo-1494059980473-813e73ee784b?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "health",
      "categoryImg":
          "https://images.unsplash.com/photo-1477332552946-cfb384aeaf1c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "science",
      "categoryImg":
          "https://images.unsplash.com/photo-1518152006812-edab29b069ac?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "sports",
      "categoryImg":
          "https://plus.unsplash.com/premium_photo-1684820878202-52781d8e0ea9?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
    {
      "categoryName": "technology",
      "categoryImg":
          "https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    },
  ];
  final List<CategoryModel> categoryList = [];
  for (var data in categories) {
    categoryList.add(
      CategoryModel(
        categoryName: data['categoryName']!,
        imgUrl: data['categoryImg']!,
      ),
    );
  }
  return categoryList;
}

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat("dd MMM yyyy, h:mm a").format(dateTime);
}

Future<List<ArticleModel>> getTopHeadlines() async {
  try {
    final String apiKey = dotenv.env['NEWS_API_KEY'] ?? "";

    if (apiKey.isEmpty) {
      throw Exception("NEWS_API_KEY missing in .env file");
    }

    final String apiUrl =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final newsResponse = NewsResponseModel.fromJson(jsonData);

      final filteredArticles =
          newsResponse.articles.where((article) {
            return article.author != null &&
                article.author!.trim().isNotEmpty &&
                article.title != null &&
                article.title!.trim().isNotEmpty &&
                article.description != null &&
                article.description!.trim().isNotEmpty &&
                article.urlToImage != null &&
                article.urlToImage!.trim().isNotEmpty &&
                article.publishedAt != null &&
                article.publishedAt!.trim().isNotEmpty;
          }).toList();

      return filteredArticles;
    } else {
      throw Exception("Failed to load news: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error fetching news: $e");
  }
}
