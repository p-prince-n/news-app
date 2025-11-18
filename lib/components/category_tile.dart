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
            child: Image.network(
              imageurl,
              height: 60,
              width: 120,
              fit: BoxFit.fill,
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
