import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayListSong {
  final String url;
  final String name;

  const PlayListSong({
    required this.url,
    required this.name
  });

  String? getId() {
    return YoutubePlayer.convertUrlToId(url);
  }

  Map<String, dynamic> toJSON() => {
    "url" : url,
    "name": name
  };
}