import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';
import '../domain/uihelper.dart';
import '../providers/music_provider.dart';
import '../pages/playsong_ui.dart';

class MyCompactMusicPlayWidget extends StatefulWidget {
  final String songTitle;
  final String albumTitle;
  final String thumbnailPath;
  final bool isBluetooth;
  final String bluetoothName;
  final double height;

  final Color bgColor;
  final double progress;

  final VoidCallback onPlayPause;

  const MyCompactMusicPlayWidget({
    super.key,
    required this.songTitle,
    required this.albumTitle,
    required this.thumbnailPath,
    this.isBluetooth = false,
    this.bluetoothName = "Redmi 5G",
    this.height = 65,
    required this.bgColor,
    required this.progress,
    required this.onPlayPause,
  });

  @override
  State<MyCompactMusicPlayWidget> createState() =>
      _MyCompactMusicPlayWidgetState();
}

class _MyCompactMusicPlayWidgetState extends State<MyCompactMusicPlayWidget> {
  PaletteGenerator? generator;

  @override
  void initState() {
    super.initState();
    _loadColor();
  }

  Future<void> _loadColor() async {
    generator = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.thumbnailPath),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);
    final isPlaying = provider.isPlaying;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaySongUI(
              songTitle: widget.songTitle,
              albumTitle: widget.albumTitle,
              thumbnailPath: widget.thumbnailPath,
              driveUrl: provider.currentDriveFileId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (generator?.dominantColor?.color ?? widget.bgColor)
              .withOpacity(0.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Thumbnail
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(widget.thumbnailPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                mSpacer(),

                // Song info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.songTitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(widget.albumTitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ),

                // Prev
                const Icon(Icons.skip_previous, color: Colors.white, size: 22),

                // Play / Pause
                IconButton(
                  onPressed: widget.onPlayPause,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      key: ValueKey(isPlaying),
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Next
                const Icon(Icons.skip_next, color: Colors.white, size: 22),
              ],
            ),

            // Progress
            LinearProgressIndicator(
              value: widget.progress,
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(
                generator?.dominantColor?.color ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


