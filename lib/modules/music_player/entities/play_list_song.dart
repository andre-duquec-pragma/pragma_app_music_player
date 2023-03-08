import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayListSong {
  final int? indexRow;
  final String urlYoutube;
  final String songName;
  final int idPragmatic;
  final String? message;
  final bool isActive;

  const PlayListSong({
    this.indexRow,
    required this.urlYoutube,
    required this.songName,
    required this.idPragmatic,
    this.message,
    this.isActive = false,
  });

  PlayListSong copyWith({
    int? indexRow,
    String? urlYoutube,
    String? songName,
    int? idPragmatic,
    bool? isActive,
  }) {
    return PlayListSong(
      indexRow: indexRow ?? this.indexRow,
      urlYoutube: urlYoutube ?? this.urlYoutube,
      songName: songName ?? this.songName,
      idPragmatic: idPragmatic ?? this.idPragmatic,
      isActive: isActive ?? this.isActive
    );
  }

  String? getId() {
    return YoutubePlayer.convertUrlToId(urlYoutube);
  }

  static PlayListSong fromJSON(Map<String, dynamic> json) => PlayListSong(
      indexRow: int.parse(json["indexRow"]),
      urlYoutube: json["urlYoutube"],
      songName: json["songName"],
      idPragmatic: int.parse(json["idPragmatic"]),
      message: json["message"]
  );

  Map<String, dynamic> toJSON() => {
    "url" : urlYoutube,
    "name": songName
  };
}