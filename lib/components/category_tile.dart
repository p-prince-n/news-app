import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String tileName;
  final String imageurl;
  const CategoryTile({
    super.key,
    required this.tileName,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: imageurl,
              height: 60,
              width: 120,
              fit: BoxFit.fill,
              placeholder:
                  (context, url) =>
                      Center(child: CircularProgressIndicator(value: 0.5)),
              errorWidget:
                  (context, url, error) => Icon(Icons.broken_image, size: 60),
            ),
          ),
          Container(
            height: 60,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black26,
            ),
            child: Text(
              tileName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
