import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/playsong_ui.dart';
import '../../providers/music_provider.dart';

class QueuePage extends StatelessWidget{
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: ListView.builder(
        itemCount: musicProvider.likedSongs.length,
        itemBuilder: (context, index) {
          final song = musicProvider.likedSongs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(song['thumbnailPath']),
            ),
            title: Text(
              song['songTitle'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song['albumTitle'],
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              musicProvider.playSong(
                songTitle: song['songTitle'],
                albumTitle: song['albumTitle'],
                thumbnailPath: song['thumbnailPath'], driveFileId: '',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaySongUI(
                    songTitle: song['songTitle'],
                    albumTitle: song['albumTitle'],
                    thumbnailPath: song['thumbnailPath'],
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
