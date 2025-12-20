import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_spotify_app/main.dart';

import 'domain/app_color.dart';

class Splashpage extends StatefulWidget {
  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  double width = 10;

  double height = 10;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      // Navigator.pushReplacementNamed(context, AppRoutes.intro_page);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> DashboardScreen()));
    });
    animate();
  }

  void animate() {
    width = 10;
    height = 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          width: 180,
          height: 180,
          child: SvgPicture.asset(
            "assets/svg/spotify_logo.svg",
            width: 70,
            height: 70,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
