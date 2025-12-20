import 'package:flutter/material.dart';
import 'package:my_spotify_app/dashboard/home/all_page.dart';
import 'package:my_spotify_app/dashboard/home/music_page.dart';
import 'package:my_spotify_app/dashboard/home/podcast_page.dart';
import 'package:my_spotify_app/dashboard/library/my_profile.dart';
import 'package:my_spotify_app/pages/singer_songs_page.dart';
import 'package:my_spotify_app/providers/music_provider.dart';
import 'package:provider/provider.dart';

import '../../Settings/settings.dart';
import '../../domain/uihelper.dart';
import '../../pages/playsong_ui.dart';
import '../library/liked_songs_page.dart';

class HomeBottomNavPage extends StatefulWidget {
  @override
  _HomeBottomNavPageState createState() => _HomeBottomNavPageState();
}

class _HomeBottomNavPageState extends State<HomeBottomNavPage> {
  int selectedFilterIndex = 0;
  final List<String> filters = ["All", "Music", "Podcasts"];

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final recentlyPlayed = musicProvider.recentlyPlayed;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // TOP ICONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  Icon(Icons.notifications_none, color: Colors.white),
                  SizedBox(width: 12),
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> SettingsPage(),),);
                    },
                      child: Icon(Icons.settings, color: Colors.white)),
                ],
              ),

              const SizedBox(height: 20),

              // FILTERS (All • Music • Podcasts)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(filters.length, (index) {
                    bool isSelected = index == selectedFilterIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedFilterIndex = index);

                        if (filters[index] == "All") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const AllPage()));
                        } else if (filters[index] == "Music") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const MusicPage()));
                        } else if (filters[index] == "Podcasts") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const PodcastPage()));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.greenAccent.withOpacity(0.3)
                              : Colors.grey[850],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          filters[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[300],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              //LIKED SONGS BOX -----------
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3.5,
                ),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LikedSongsPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            child: Image.asset(
                              "assets/images/liked.jpeg",
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Liked Songs",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // RECENTLY PLAYED
              if (recentlyPlayed.isNotEmpty) ...[
                const Text(
                  "Recently Played",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentlyPlayed.length,
                  itemBuilder: (context, index) {
                    final track = recentlyPlayed[index];
                    return ListTile(
                      onTap: () {
                        final provider = Provider.of<MusicProvider>(context, listen: false);

                        provider.playSong(
                          songTitle: track['title']!,
                          albumTitle: track['album']!,
                          thumbnailPath: track['image']!,
                          driveFileId: '',
                         // artistName: track['artist']!,
                        );

                        // Navigate to your full play page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaySongUI(
                              songTitle: track['title']!,
                              albumTitle: track['album']!,
                              thumbnailPath: track['image']!,
                             // artistName: track['artist']!,
                            ),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          track['image']!,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        track['title']!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${track['album']} • ${track['artist']}",
                        style: const TextStyle(color: Colors.white70),
                      ),

                      trailing: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 32,
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 100),
              Text('Favourates',style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              mSpacer(),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: 
                              (context)=>SingerSongsPage(singerName: "shubh", category: "punjabi")));
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/images/shubh.jpeg"),
                            fit:BoxFit.cover),borderRadius: BorderRadius.circular(11),
                          ),
                           child: Text("Shubh",style:TextStyle(color:Colors.white))
                        ),
                      ),mSpacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SingerSongsPage(singerName: "Aijit Singh", category: "Hindi")));
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/aijit singh.jpeg"),
                                  fit:BoxFit.cover),borderRadius: BorderRadius.circular(11)
                          ),
                        ),
                      ),mSpacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SingerSongsPage(singerName: "Diljit", category: "punjabi")));
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/diljit.jpeg"),
                                  fit:BoxFit.cover),borderRadius: BorderRadius.circular(11)
                          ),
                        ),
                      ),
                      mSpacer(),
                      InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder:
                              (context)=>SingerSongsPage(singerName: "Masum Sharma", category: "Haryanvi")));
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/masoom.jpeg"),
                                  fit:BoxFit.cover),borderRadius: BorderRadius.circular(11)
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),

        ),
      ),
    );
  }
}



