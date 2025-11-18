import 'package:news_app/models/source_model.dart';

class ArticleModel {
  final SourceModel source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String? publishedAt; // or DateTime
  final String? content;

  ArticleModel({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(json["source"]),
      author: json["author"],
      title: json["title"] ?? "",
      description: json["description"],
      url: json["url"] ?? "",
      urlToImage: json["urlToImage"],
      publishedAt: json["publishedAt"] ?? "",
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "source": source.toJson(),
      "author": author,
      "title": title,
      "description": description,
      "url": url,
      "urlToImage": urlToImage,
      "publishedAt": publishedAt,
      "content": content,
    };
  }
}
