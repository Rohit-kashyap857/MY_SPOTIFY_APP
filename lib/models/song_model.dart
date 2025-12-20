class SongModel {
  final String id; // unique id, we will use google drive file id (or any unique string)
  final String title;
  final String artist;
  final String albumArtUrl; // optional: cover image url
  final String driveFileId; // google drive file id

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.driveFileId,
    this.albumArtUrl = '',
  });

  // helper to build direct playable URL from driveFileId
  String get directUrl {
    // Drive direct download URL pattern
    return 'https://drive.google.com/uc?export=download&id=$driveFileId';
   // return '  https://drive.google.com/file/d/1gn2gnNSTBQQF2q1t5e702nnShKTQy7KX/view?usp=drive_link';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'albumArtUrl': albumArtUrl,
    'driveFileId': driveFileId,
  };

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
    id: json['id'],
    title: json['title'],
    artist: json['artist'],
    albumArtUrl: json['albumArtUrl'] ?? '',
    driveFileId: json['driveFileId'],
  );
}
