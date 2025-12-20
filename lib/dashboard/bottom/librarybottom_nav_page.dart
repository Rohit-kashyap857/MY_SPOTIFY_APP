import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:my_spotify_app/pages/singer_songs_page.dart';
import '../../customwidget/my_library_likedwidget.dart';
import '../../customwidget/type_chipwidget.dart';
import '../../domain/app_color.dart';
import '../../domain/uihelper.dart';
import '../library/liked_songs_page.dart';
import '../library/my_profile.dart';
import '../library/queue_page.dart';

class LibraryBottomNavPage extends StatefulWidget {
  const LibraryBottomNavPage({super.key});

  @override
  State<LibraryBottomNavPage> createState() => _LibraryBottomNavPageState();
}

class _LibraryBottomNavPageState extends State<LibraryBottomNavPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> mTypes = ["Playlists", "Artists", "Albums", "Podcasts & shows"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.blackColor,
        endDrawer: const MyProfile(), //  Side profile drawer
        body: Column(
          children: [
            mSpacer(),
            titleUi(context),
            mSpacer(),
            typeChipUi(),
            mSpacer(mHeight: 16),
            recentlyPlayedUi(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    mSpacer(mHeight: 16),
                    InkWell(
                      child: MyLibraryLikedwidget(
                        mTitle: "Liked Songs",
                        mSubTitle: "PlayList | 58 songs",
                        isLeadingGradient: false,
                        mGradientColors: [],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LikedSongsPage(),
                          ),
                        );
                      },
                    ),
                    mSpacer(mHeight: 3),
                    InkWell(
                      child: MyLibraryLikedwidget(
                        mTitle: "Add to Queue",
                        mSubTitle: "Uploaded | 2 days ago",
                        mSolidColor: Colors.purple,
                        mLeadingIcon: Icons.notifications_active,
                        mLeadingIconColor: Colors.green,
                      ),
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QueuePage(),
                          ),
                        );
                      }
                    ),
                    mSpacer(),
                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SingerSongsPage(
                                        singerName: "shubh", category: "punjabi"),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Image.asset(
                                  "assets/images/shubh.jpeg",
                                  width: 60,
                                  height: 60,
                                ),
                                title: const Text("Shubh"),
                                subtitle: const Text("Artist"),
                                titleTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitleTextStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            mSpacer(mHeight: 14),
                          ],
                        );
                      },
                    ),
                    mSpacer(),
                   InkWell(
                       child: Center(child:Icon(Icons.add,color:Colors.grey,size:60),),
                       onTap:(){}
                   ),
                    Text("Add Artist",style: TextStyle(color:Colors.grey,fontSize: 14),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Title Row with Profile on Tap
  Widget titleUi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage: const AssetImage("assets/images/image 2.png"),
            ),
          ),
          mSpacer(),
          const Text(
            "Your Library",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.add, size: 30, color: Colors.grey),
        ],
      ),
    );
  }

  Widget typeChipUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          itemCount: mTypes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return TypeChipwidget(typeName: mTypes[index]);
          },
        ),
      ),
    );
  }

  Widget recentlyPlayedUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.compare_arrows_sharp,
              color: Colors.white,
              size: 15,
            ),
          ),
          mSpacer(mWidth: 1),
          const Text(
            "Recently played",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          SvgPicture.asset("assets/svg/shuffle.svg", color: Colors.white),
        ],
      ),
    );
  }
}