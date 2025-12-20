import 'package:flutter/material.dart';
import 'package:my_spotify_app/domain/app_color.dart';
import 'package:palette_generator/palette_generator.dart';


Widget mSpacer({double mWidth = 11, double mHeight = 11}) =>
    SizedBox(width: mWidth, height: mHeight);
InputDecoration getCreateAccTextFieldDecoration() => InputDecoration(
  //contentPadding: EdgeInsets.zero,
  filled: true,
  fillColor: AppColors.greyColor,
  enabledBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: BorderSide(color: AppColors.primaryColor,
    width:2,
    )
  )
);
InputDecoration getSearchAccTextFieldDecoration({IconData mIcon = Icons.search, 
Color bgColor = Colors.white, String mText = "search"}) => InputDecoration(
  contentPadding: EdgeInsets.zero,
  filled: true,
  fillColor: AppColors.whiteColor,
  hintText: mText,
  prefixIcon: Icon(mIcon),
  hintStyle: TextStyle(color: AppColors.secondaryBlackColor),
  enabledBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
   
  )
 
);
Future<PaletteGenerator> getColorPalette(String imagePath) async {
     return await PaletteGenerator.fromImageProvider(
      AssetImage(imagePath),
    );
  }
