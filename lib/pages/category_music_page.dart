import 'package:flutter/material.dart';
import 'package:my_spotify_app/pages/playsong_ui.dart';
import 'package:my_spotify_app/pages/singer_songs_page.dart';

import '../domain/app_color.dart';

class CategoryMusicPage extends StatelessWidget {
  final String categoryname;
  CategoryMusicPage({required this.categoryname});

  final Map<String, List<Map<String, dynamic>>> categorySingers = {
    "Punjabi": [
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
    ],
    "Hindi": [
      {"imagePath": "assets/images/aijit singh.jpeg", "name": "Aijit Singh"},
      {"imagePath": "assets/images/aijit singh.jpeg", "name": "Aijit Singh"},
      {"imagePath": "assets/images/aijit singh.jpeg", "name": "Aijit Singh"},
      {"imagePath": "assets/images/masoom.jpeg", "name": "Masum Sharma"},
      {"imagePath": "assets/images/masoom.jpeg", "name": "Masum Sharma"},
      {"imagePath": "assets/images/masoom.jpeg", "name": "Masum Sharma"},
    ],
    "Pop": [
      {"imagePath": "assets/images/aijit singh.jpeg", "name": "Aijit Singh"},
      {"imagePath": "assets/images/aijit singh.jpeg", "name": "Aijit Singh"},
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/masoom.jpeg", "name": "Masum Sharma"},
      {"imagePath": "assets/images/masoom.jpeg", "name": "Masum Sharma"},
    ],
    "Made For You": [
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/shubh.jpeg", "name": "Shubh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
      {"imagePath": "assets/images/diljit.jpeg", "name": "Diljit Dosanjh"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final singers = categorySingers[categoryname] ?? [];

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          categoryname,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),


      body: ListView.builder(
        itemCount: singers.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(singers[index]["imagePath"]),
            ),

            title: Text(
              singers[index]["name"],
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaySongUI(
                          songTitle: singers[index]["name"],
                          albumTitle: categoryname,
                          thumbnailPath: singers[index]["imagePath"],
                        ),
                      ),
                    );
                  },
                ),

                // THREE DOTS MENU
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  color: Colors.grey[900],
                  onSelected: (value) {
                    if (value == "play") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaySongUI(
                            songTitle: singers[index]["name"],
                            albumTitle: categoryname,
                            thumbnailPath: singers[index]["imagePath"],
                          ),
                        ),
                      );
                    } else if (value == "add_queue") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Added to Queue")),
                      );
                    } else if (value == "view_songs") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SingerSongsPage(
                            singerName: singers[index]["name"],
                            category: categoryname,
                          ),
                        ),
                      );
                    }
                  },

                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "play",
                      child: Text("Play Song", style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: "add_queue",
                      child: Text("Add to Queue", style: TextStyle(color: Colors.white)),
                    ),
                    const PopupMenuItem(
                      value: "view_songs",
                      child: Text("View All Songs", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SingerSongsPage(
                    singerName: singers[index]["name"],
                    category: categoryname,
                  ),
                ),
              );
            },
          );
        },

      ),
    );
  }}
