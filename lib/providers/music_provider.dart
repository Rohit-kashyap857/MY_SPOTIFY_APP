import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/song_model.dart';

class MusicProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _likedSongs = [];
  List<Map<String, dynamic>> get likedSongs => _likedSongs;

  MusicProvider() {
    loadLikedSongs();
  }
  String extractDriveId(String urlOrId) {
    // if already short (looks like an id)
    final idOnlyReg = RegExp(r'^[A-Za-z0-9_-]{10,}$');
    if (idOnlyReg.hasMatch(urlOrId)) return urlOrId;

    // common Drive URL patterns
    final patterns = [
      RegExp(r'/d/([A-Za-z0-9_-]+)'),
      RegExp(r'id=([A-Za-z0-9_-]+)'),
      RegExp(r'open\?id=([A-Za-z0-9_-]+)'),
      RegExp(r'file/d/([A-Za-z0-9_-]+)'),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(urlOrId);
      if (m != null && m.groupCount >= 1) return m.group(1)!;
    }

    // fallback: attempt to strip query params and last path segment
    try {
      final uri = Uri.parse(urlOrId);
      final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      if (idOnlyReg.hasMatch(last)) return last;
    } catch (e) {
      // ignore parse errors
    }

    // if nothing found, return original (so caller can detect failure)
    return urlOrId;
  }


  Future<void> saveLikedSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = _likedSongs.map((song) => jsonEncode(song)).toList();
    await prefs.setStringList("likedSongs", data);
  }

  Future<void> loadLikedSongs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("likedSongs");

    if (data != null) {
      try {
        _likedSongs = data
            .where((item) => item.isNotEmpty)
            .map((item) => jsonDecode(item) as Map<String, dynamic>)
            .toList();
      } catch (e) {
        _likedSongs = [];
        prefs.remove("likedSongs");
      }
    }

    notifyListeners();
  }

  void addLikedSong(Map<String, dynamic> song) {
    if (!_likedSongs.any((s) => s['songTitle'] == song['songTitle'])) {
      _likedSongs.add(song);
      saveLikedSongs();
      notifyListeners();
    }
  }

  void removeLikedSong(String title) {
    _likedSongs.removeWhere((song) => song['songTitle'] == title);
    saveLikedSongs();
    notifyListeners();
  }

  bool isSongLiked(String title) {
    return _likedSongs.any((song) => song['songTitle'] == title);
  }

  // ======================= RECENT SONGS ======================
  final List<Map<String, String>> _recentlyPlayed = [];
  List<Map<String, String>> get recentlyPlayed => _recentlyPlayed;

  void _addToRecentlyPlayed(String title, String album, String image) {
    final existingIndex =
    _recentlyPlayed.indexWhere((song) => song['title'] == title);

    if (existingIndex != -1) {
      final existingSong = _recentlyPlayed.removeAt(existingIndex);
      _recentlyPlayed.insert(0, existingSong);
    } else {
      _recentlyPlayed.insert(0, {
        'title': title,
        'album': album,
        'image': image,
      });
    }
  }

  bool isPlaying = false;
  String songTitle = "";
  String albumTitle = "";
  String thumbnailPath = "";
  String currentSongUrl = "";
  String currentDriveFileId = "";
  double progress = 0.0;

  List<SongModel> currentPlayList = [];
  int currentIndex = 0;

  void updateProgress(Duration position, Duration duration){
    if (duration.inMilliseconds ==0)
      return;
    progress = position.inMilliseconds/duration.inMilliseconds;
    notifyListeners();
  }

  void setPlayList(List<SongModel> songs, int index) {
    currentPlayList = songs;
    currentIndex = index;
  }

  void playSong({
    required String songTitle,
    required String albumTitle,
    required String thumbnailPath,
    required String driveFileId,
  }) {
    this.songTitle = songTitle;
    this.albumTitle = albumTitle;
    this.thumbnailPath = thumbnailPath;

    if (driveFileId.isNotEmpty) {
      final fileId = extractDriveId(driveFileId);
      currentDriveFileId = fileId;
      currentSongUrl =
      "https://drive.google.com/uc?export=download&id=$driveFileId";
    }

    isPlaying = true;

    _addToRecentlyPlayed(songTitle, albumTitle, thumbnailPath);
    notifyListeners();
  }

  void pauseSong() {
    isPlaying = false;
    notifyListeners();
  }

  void resumeSong() {
    isPlaying = true;
    notifyListeners();
  }

  void stopSong() {
    isPlaying = false;
    songTitle = "";
    albumTitle = "";
    thumbnailPath = "";
    notifyListeners();
  }
  void togglePlayPause(){
    isPlaying =! isPlaying;
    notifyListeners();
  }

  void playNextSong() {
    if (currentPlayList.isEmpty) return;

    currentIndex++;
    if (currentIndex >= currentPlayList.length) currentIndex = 0;

    final nextSong = currentPlayList[currentIndex];

    playSong(
      songTitle: nextSong.title,
      albumTitle: nextSong.artist,
      thumbnailPath: nextSong.albumArtUrl,
      driveFileId: nextSong.driveFileId,
    );
  }
}

