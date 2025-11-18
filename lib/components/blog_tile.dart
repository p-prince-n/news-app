// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constants/constant.dart';
import 'package:news_app/views/artical_views.dart';

class BlogTile extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String articalUrl;
  final VoidCallback toggleTheme;
  final bool isDark;
  const BlogTile({
    Key? key,
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.articalUrl,
    required this.toggleTheme,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ArticalViews(
                    articalUrl: articalUrl,
                    toggleTheme: toggleTheme,
                    isDark: isDark,
                  ),
            ),
          );
        },
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ).copyWith(top: 15),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: urlToImage,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            Icon(Icons.broken_image, size: 60),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        formatDate(publishedAt),
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        author.length > 20
                            ? "${author.substring(0, 20)}..."
                            : author,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
