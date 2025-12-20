import 'package:flutter/material.dart';
import '../domain/uihelper.dart';

class MyLibraryLikedwidget extends StatelessWidget {
  bool isLeadingGradient;
  List<Color>? mGradientColors;
  Color? mSolidColor;
  IconData mLeadingIcon;
  Color mLeadingIconColor;
  String mTitle;
  String mSubTitle;

  MyLibraryLikedwidget({
    required this.mTitle,
    required this.mSubTitle,
    this.mLeadingIcon = Icons.favorite,
    this.mSolidColor,
    this.isLeadingGradient = false,
    this.mLeadingIconColor = Colors.white,
    this.mGradientColors,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        child: Icon(mLeadingIcon, color: Colors.white),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: mSolidColor ?? Colors.indigo,
          gradient: isLeadingGradient
              ? LinearGradient(
            colors:
            mGradientColors ??
                [Color(0xff4A39EA), Color(0xff868AE1), Color(0xffB9D4DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
      ),
      title: Text(mTitle),
      titleTextStyle: TextStyle(color:Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
      subtitleTextStyle: TextStyle(color:Colors.grey,fontSize: 12),
      subtitle:Row(
        children: [
          Icon(Icons.push_pin,color: Colors.green,size:15),
          mSpacer(mWidth: 2),
          Text(mSubTitle),
        ],
      ),
    );
  }
}

