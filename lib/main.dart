import 'package:flutter/material.dart';
import 'package:my_spotify_app/providers/music_provider.dart';
import 'package:my_spotify_app/splash_page.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'customwidget/my_compact_music_play_widget.dart';
import 'dashboard/bottom/homebottom_nav_page.dart';
import 'dashboard/bottom/librarybottom_nav_page.dart';
import 'dashboard/bottom/searchbottom_nav_page.dart';
import 'domain/app_color.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_)=> MusicProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashpage(),
      ),
    );
  }
}
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PaletteGenerator? paletteGenerator;
  double currentvalue = 34;
  int selectedBottomIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    initializePaletteGenerator();
  }

  Future<void> initializePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      const AssetImage("assets/images/shubh.jpeg"),
    );
    setState(() {});
  }

  /// bottom nav navigator builder
  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: selectedBottomIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (_) {
              switch (index) {
                case 0:
                  return  HomeBottomNavPage();
                case 1:
                  return  SearchBottomNavPage();
                case 2:
                  return const LibraryBottomNavPage();
              //  case 3:
              //  return const MyProfile();
                default:
                  return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// main pages with independent navigation
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          // _buildOffstageNavigator(3),

          /// compact music player always visible (except on Profile)
         if (selectedBottomIndex != 3)

           Align(
              alignment: Alignment.bottomCenter,
              child: Consumer<MusicProvider>(
                builder: (context, music, child) {
                  if (music.songTitle.isEmpty) return const SizedBox();
                  return MyCompactMusicPlayWidget(
                    songTitle: music.songTitle,
                    albumTitle: music.albumTitle,
                    thumbnailPath: music.thumbnailPath,
                    bgColor: Colors.grey.shade900,
                    progress: music.progress,
                    onPlayPause: () => music.togglePlayPause(),
                  );
                },
              ),
            ),
        ],
      ),

      /// bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.secondaryBlackColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.greyColor,
        onTap: (value) => setState(() => selectedBottomIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Library"),
          //  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}





