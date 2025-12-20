import 'package:flutter/material.dart';
import 'package:my_spotify_app/pages/playsong_ui.dart';
import 'package:provider/provider.dart';

import '../domain/app_color.dart';
import '../providers/music_provider.dart';


class SingerSongsPage extends StatelessWidget {
  final String singerName;
  final String category;

  SingerSongsPage({
    required this.singerName,
    required this.category,
  });

  final Map<String, Map<String, List<Map<String, String>>>> categorySongs = {
    "Hindi": {
      "Arijit Singh": [
        {"title": "Tum Hi Ho", "image": "assets/images/aijit singh.jpeg"},
        {"title": "Channa Mereya", "image": "assets/images/aijit singh.jpeg"},
      ],
      "Armaan Malik": [
        {"title": "Bol Do Na Zara", "image": "assets/images/arman.jpg"},
      ],
    },
    "Punjabi": {
      "Shubh": [
        {"title": "Baller", "image": "assets/images/shubh.jpeg",},
        {"title": "Cheques", "image": "assets/images/shubh.jpeg"},
      ],
      "Diljit Dosanjh": [
        {"title": "Born to Shine", "image": "assets/images/diljit.jpeg"},
        {"title": "Poplin", "image": "assets/images/diljit.jpeg"},
        {"title": "Born to Shine", "image": "assets/images/diljit.jpeg"},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final songs = categorySongs[category]?[singerName] ?? [];

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          singerName,
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
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(song["image"]!),
            ),
            title: Text(
              song["title"]!,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              //  Update MusicProvider when song is clicked
              Provider.of<MusicProvider>(context, listen: false).playSong(
                songTitle: song["title"]!,
                albumTitle: singerName,
                thumbnailPath: song["image"]!,
                driveFileId: 'https://drive.google.com/file/d/1gn2gnNSTBQQF2q1t5e702nnShKTQy7KX/view?usp=drive_link',
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaySongUI(
                    songTitle: song["title"]!,
                    albumTitle: singerName,
                    thumbnailPath: song["image"]!,
                    driveUrl: 'https://drive.google.com/file/d/1gn2g.../view?usp=drive_link',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}