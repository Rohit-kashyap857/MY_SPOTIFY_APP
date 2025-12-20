import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';

import '../providers/music_provider.dart';
import '../domain/uihelper.dart';
import '../domain/app_color.dart';

class PlaySongUI extends StatefulWidget {
  final String songTitle;
  final String albumTitle;
  final String thumbnailPath;
  final String? driveUrl;

  const PlaySongUI({
    super.key,
    required this.songTitle,
    required this.albumTitle,
    required this.thumbnailPath,
    this.driveUrl,
  });

  @override
  State<PlaySongUI> createState() => _PlaySongUIState();
}

class _PlaySongUIState extends State<PlaySongUI>
    with SingleTickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  late AnimationController rotation;

  Color dominantColor = Colors.black;
  String songUrl = "";

  bool get isPlaying =>
      Provider.of<MusicProvider>(context, listen: true).isPlaying;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    rotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _loadColor();
    _initAudio();
  }

  Future<void> _loadColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.thumbnailPath),
    );

    setState(() {
      dominantColor = palette.dominantColor?.color ?? Colors.grey.shade900;
    });
  }

  Future<void> _initAudio() async {
    final provider = Provider.of<MusicProvider>(context, listen: false);

    // First tell provider this is the current song
    provider.playSong(
      songTitle: widget.songTitle,
      albumTitle: widget.albumTitle,
      thumbnailPath: widget.thumbnailPath,
      driveFileId: widget.driveUrl ?? "",
    );

    songUrl = provider.currentSongUrl;

    await audioPlayer.setSourceUrl(songUrl);

    // Listen to playback
    audioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    audioPlayer.onPositionChanged.listen((p) => setState(() => position = p));

    audioPlayer.onPlayerComplete.listen((_) {
      provider.playNextSong();
    });

    // Start playback
    await audioPlayer.resume();
    rotation.repeat();
  }

  Future<void> _playPause() async {
    final provider = Provider.of<MusicProvider>(context, listen: false);

    if (provider.isPlaying) {
      await audioPlayer.pause();
      rotation.stop();
      provider.pauseSong();
    } else {
      await audioPlayer.resume();
      rotation.repeat();
      provider.resumeSong();
    }
  }

  @override
  void dispose() {
    rotation.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  String _fmt(Duration d) =>
      "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dominantColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.albumTitle,style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          mSpacer(mHeight: 30),

          Expanded(
            child: Center(
              child: RotationTransition(
                turns: rotation,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(widget.thumbnailPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Text(widget.songTitle,
                style: const TextStyle(fontSize: 22, color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.albumTitle,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(width: 10),

              // Like button beside singer name
              SizedBox(
                height: 28,
                width: 28,
                child: LikedButtonWidget(
                  songTitle: widget.songTitle,
                  albumTitle: widget.albumTitle,
                  thumbnailPath: widget.thumbnailPath,
                ),
              ),
            ],
          ),

          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
            onChanged: (v) async {
              final newPos = Duration(seconds: v.toInt());
              await audioPlayer.seek(newPos);
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(position), style: const TextStyle(color: Colors.white70)),
                Text(_fmt(duration), style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.skip_previous, size: 40, color: Colors.white),

              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 70,
                  color: Colors.white,
                ),
                onPressed: _playPause,
              ),

              const Icon(Icons.skip_next, size: 40, color: Colors.white),
            ],
          ),

          mSpacer(mHeight: 30),
        ],
      ),
    );
  }
}

class LikedButtonWidget extends StatefulWidget {
  final String songTitle;
  final String albumTitle;
  final String thumbnailPath;

  const LikedButtonWidget({
    Key? key,
    required this.songTitle,
    required this.albumTitle,
    required this.thumbnailPath,
  }) : super(key: key);

  @override
  State<LikedButtonWidget> createState() => _LikedButtonWidgetState();
}

class _LikedButtonWidgetState extends State<LikedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    final isLiked = musicProvider.isSongLiked(widget.songTitle);

    return IconButton(
      onPressed: () {
        if (isLiked) {
          musicProvider.removeLikedSong(widget.songTitle);
        } else {
          musicProvider.addLikedSong({
            'songTitle': widget.songTitle,
            'albumTitle': widget.albumTitle,
            'thumbnailPath': widget.thumbnailPath,
          });
        }
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isLiked),
          color: isLiked ? Colors.green : Colors.white,
        ),
      ),
    );
  }
}
