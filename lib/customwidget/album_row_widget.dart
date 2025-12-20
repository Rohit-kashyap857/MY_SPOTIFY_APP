import 'dart:math';
import 'package:flutter/material.dart';

class AlbumRowWidget extends StatelessWidget {
  String thumbnailPath;
  String albumName;

  AlbumRowWidget({required this.thumbnailPath, required this.albumName});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 11),
      width: MediaQuery.of(context).size.width*0.5-22,//media query provide details padding and other.
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length - 1)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -8,
            child: Transform.rotate(
              angle: 15 * pi / 180,
              child: Container(
                width: 70,
                height: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 4,
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                  image: DecorationImage(image: AssetImage(thumbnailPath)),
                ),
              ),
            ),
          ),
          Positioned(
              top: 11,
              left: 11,
              child: Text(albumName, style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }
}
