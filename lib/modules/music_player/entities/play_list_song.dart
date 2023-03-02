import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayListSong {
  final String url;
  final String name;
  final bool isActive;

  const PlayListSong({
    required this.url,
    required this.name,
    this.isActive = false,
  });

  PlayListSong copyWith({
    String? url,
    String? name,
    bool? isActive,
  }) {
    return PlayListSong(
      url: url ?? this.url,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive
    );
  }

  String? getId() {
    return YoutubePlayer.convertUrlToId(url);
  }

  Map<String, dynamic> toJSON() => {
    "url" : url,
    "name": name
  };
}